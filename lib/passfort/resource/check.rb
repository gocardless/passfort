# frozen_string_literal: true

module Passfort
  module Resource
    class Check < Base
      attributes :id, :check_type, :state, :input_data, :output_data, :result,
                 :performed_on, :errors, :task_ids, :instructed_externally
    end
  end
end
