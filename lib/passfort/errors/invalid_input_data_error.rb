# frozen_string_literal: true

module Passfort
  module Errors
    # Specific error class for when an invalid input data is used to query the service
    class InvalidInputDataError < APIError
      def initialize(*args)
        super("Invalid input data", *args)
      end
    end
  end
end
