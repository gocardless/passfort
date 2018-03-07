# frozen_string_literal: true

module Passfort
  module Errors
    # Represents any response from the API which is not a 200 OK
    class APIError < StandardError
      attr_reader :response

      def initialize(msg, response = nil)
        super(msg)
        @response = response
      end
    end
  end
end
