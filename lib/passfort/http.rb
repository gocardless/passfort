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
    rescue JSON::ParserError
      raise Passfort::Errors::UnparseableResponseError.new([], response)
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
    rescue JSON::ParserError
      raise Passfort::Errors::UnparseableResponseError.new([], response)
    end

    private

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
  end
end
