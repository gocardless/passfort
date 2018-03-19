# frozen_string_literal: true

module Passfort
  module Errors
    # Specific error class for when an unknown error is returned
    class UnknownApiError < APIError
      def initialize(*args)
        super("Unknown API error", *args)
      end
    end
  end
end
