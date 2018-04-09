# frozen_string_literal: true

require "active_support/notifications"
require "excon"
require "json"

module Passfort
  class Http
    DOMAIN = "https://api.passfort.com"
    ROOT_PATH = "/4.0"

    attr_reader :api_key, :connection

    def initialize(api_key, excon_opts = {})
      @api_key = api_key
      uri = excon_opts[:domain] || DOMAIN
      @connection = Excon.new(uri, excon_opts.except(:domain))
    end

    def get(path)
      execute(
        -> {
          @connection.get(
            path: ROOT_PATH + path,
            headers: { apikey: @api_key },
          )
        },
        :get,
        path: path,
      )
    end

    def post(path, body:)
      execute(
        -> {
          @connection.post(
            path: ROOT_PATH + path,
            body: body.to_json,
            headers: { apikey: @api_key, "Content-Type" => "application/json" },
          )
        },
        :post,
        path: path,
        body: body,
      )
    end

    private

    def execute(get_response, method, payload)
      started = Time.now
      response = get_response.call
      payload[:response] = response.body
      body = JSON.parse(response.body)
      handle_error(response, body)
      body
    rescue JSON::ParserError => raw_error
      payload[:error] = raw_error
      raise Passfort::Errors::UnparseableResponseError.new([], response)
    rescue Excon::Errors::Timeout => raw_error
      payload[:error] = raw_error
      raise Passfort::Errors::TimeoutError
    ensure
      publish("passfort.#{method}", started, Time.now, SecureRandom.hex(10), payload)
    end

    # error codes: https://passfort.com/developer/v4/data-reference/ErrorCodes
    def handle_error(response, body)
      unless [200, 201].include?(response.status)
        raise Passfort::Errors::RequestError.new([], response)
      end

      errors = body["errors"].is_a?(Array) ? body["errors"] : [body["errors"]]

      handle_response_error(errors, response) if errors.any?
    end

    def handle_response_error(errors, response)
      error_class = case errors[0]["code"]
                    when 201 then Passfort::Errors::InvalidInputDataError
                    when 204 then Passfort::Errors::InvalidAPIKeyError
                    when 104 then Passfort::Errors::ChargeableLimitReachedError
                    else Passfort::Errors::UnknownApiError
                    end
      raise error_class.new(errors, response)
    end

    def publish(*args)
      ActiveSupport::Notifications.publish(*args)
    end
  end
end
