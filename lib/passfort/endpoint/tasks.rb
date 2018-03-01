# frozen_string_literal: true

module Passfort
  module Endpoint
    class Tasks
      def initialize(client)
        @client = client
      end

      def find(profile_id:, task_id:)
        response = @client.get("/profiles/#{profile_id}/tasks/#{task_id}")
        Passfort::Resource::Task.new(response)
      end
    end
  end
end
