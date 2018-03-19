# frozen_string_literal: true

module Passfort
  module Errors
    # Specific error class for when an invalid API key is used to access the service
    class InvalidAPIKeyError < APIError
      def initialize(*args)
        super("Invalid API key", *args)
      end
    end
  end
end
