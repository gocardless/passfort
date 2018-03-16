# frozen_string_literal: true

module Passfort
  module Errors
    # Represents any response from the API which is not a 200 OK
    class APIError < StandardError
      attr_reader :response, :errors

      def initialize(msg, errors = [], response = nil)
        super(msg)
        @response = response
        @errors = errors
      end
    end
  end
end
