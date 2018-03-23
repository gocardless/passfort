# frozen_string_literal: true

module Passfort
  module Errors
    class UnparseableResponseError < APIError
      def initialize(*args)
        super("Unparseable response body", *args)
      end
    end
  end
end
