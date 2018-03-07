# frozen_string_literal: true

module Passfort
  module Errors
    # Specific error class for when an HTTP request error has occurred
    class RequestError < APIError
      def initialize(response)
        super("Request API error - HTTP #{response.status}", response)
      end
    end
  end
end
