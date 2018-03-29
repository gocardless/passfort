# frozen_string_literal: true

module Passfort
  module Errors
    # Specific error class for when an HTTP request has timed out
    class TimeoutError < APIError
      def initialize
        super("Request timed out")
      end
    end
  end
end
