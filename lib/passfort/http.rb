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
      raise Passfort::RequestError, body unless response.status == 200
      body
    end

    def post(path, body:)
      response = @connection.post(
        path: ROOT_PATH + path,
        body: body.to_json,
        headers: { apikey: @api_key, "Content-Type" => "application/json" },
      )
      body = JSON.parse(response.body)
      raise Passfort::RequestError, body unless [200, 201].include?(response.status)
      body
    end
  end
end
