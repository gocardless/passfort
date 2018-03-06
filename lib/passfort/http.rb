# frozen_string_literal: true

require "json"
require "excon"

module Passfort
  class Http
    DOMAIN = "https://api.passfort.com"
    ROOT_PATH = "/4.0"

    def initialize(api_key, connection: Excon.new(DOMAIN))
      @api_key = api_key
      @connection = connection
    end

    def get(path)
      response = @connection.get(path: ROOT_PATH + path, headers: { apikey: @api_key })
      body = JSON.parse(response.body)
      handle_error(response, body)
      body
    end

    def post(path, body:)
      response = @connection.post(
        path: ROOT_PATH + path,
        body: body.to_json,
        headers: { apikey: @api_key, "Content-Type" => "application/json" },
      )
      body = JSON.parse(response.body)
      handle_error(response, body)
      body
    end

    private

    # error codes: https://passfort.com/developer/v4/data-reference/ErrorCodes
    def handle_error(response, body)
      unless [200, 201].include?(response.status)
        raise Passfort::Errors::RequestError, response
      end

      errors = body["errors"].is_a?(Array) ? body["errors"] : [body["errors"]]

      handle_response_error(errors[0], response) if errors.any?
    end

    def handle_response_error(error, response)
      case error["code"]
      when 201
        raise Passfort::Errors::InvalidInputDataError, response
      when 204
        raise Passfort::Errors::InvalidAPIKeyError, response
      when 104
        raise Passfort::Errors::ChargeableLimitReachedError, response
      else
        raise Passfort::Errors::APIError.new("Unknown API error", response)
      end
    end
  end
end
