# frozen_string_literal: true

module Passfort
  module Errors
    # Specific error class for when an HTTP request error has occurred
    class RequestError < APIError
      def initialize(errors, response)
        super("Request API error - HTTP #{response.status}", errors, response)
      end
    end
  end
end
