# frozen_string_literal: true

module Passfort
  module Resource
    class Base
      def self.attributes(*keys)
        keys.each { |key| define_method(key) { @attributes[key] } }
      end

      def initialize(attributes)
        @attributes = attributes.symbolize_keys
      end

      def to_h
        @attributes
      end
    end
  end
end
