# frozen_string_literal: true

require "passfort/resource/task"

module Passfort
  module Resource
    class Profile < Base
      attributes :id, :role, :collected_data, :verified_data, :checks,
                 :collection_steps, :display_name, :applications, :task_types,
                 :tasks, :events, :category, :status, :document_images, :tags,
                 :risk, :unresolved_event_types, :task_progress,
                 :has_associates, :has_collection_steps
    end
  end
end
