# frozen_string_literal: true

require "active_support/core_ext/hash"

module Passfort
  module Resource
    class Base
      def self.attributes(*keys)
        keys.each { |key| define_method(key) { @attributes[key] } }
      end

      def initialize(attributes)
        @attributes = attributes.with_indifferent_access
      end

      def to_h
        @attributes
      end
    end
  end
end
