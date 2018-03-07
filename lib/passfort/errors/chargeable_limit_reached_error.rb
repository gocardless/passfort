# frozen_string_literal: true

module Passfort
  module Errors
    # Specific error class for when the chargeable limit has been reached
    class ChargeableLimitReachedError < APIError
      def initialize(response = nil)
        super("Rate limit exceeded", response)
      end
    end
  end
end
