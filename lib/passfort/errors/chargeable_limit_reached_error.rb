# frozen_string_literal: true

module Passfort
  module Errors
    # Specific error class for when the chargeable limit has been reached
    class ChargeableLimitReachedError < APIError
      def initialize(*args)
        super("Rate limit exceeded", *args)
      end
    end
  end
end
