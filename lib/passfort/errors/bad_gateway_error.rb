# frozen_string_literal: true

module Passfort
  module Errors
    # Specific error class for when an HTTP request returned a 502
    class BadGatewayError < APIError
      def initialize
        super("Request returned a bad gateway error")
      end
    end
  end
end
