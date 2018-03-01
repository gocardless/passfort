# frozen_string_literal: true

require "active_support/core_ext/hash"
require "passfort/resource/task"

module Passfort
  module Resource
    class Profile
      ATTRIBUTES = %i[
        id role collected_data verified_data checks collection_steps display_name
        applications task_types tasks events category status document_images tags risk
        unresolved_event_types task_progress has_associates has_collection_steps
      ].freeze

      ATTRIBUTES.each do |a|
        define_method(a) { @attributes[a] }
      end

      def tasks
        @attributes[:tasks].map { |t| Task.new(t) }
      end

      def initialize(attributes)
        @attributes = attributes.symbolize_keys
      end
    end
  end
end
