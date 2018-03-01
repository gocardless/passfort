# frozen_string_literal: true

require "passfort/resource/profile"

module Passfort
  module Endpoint
    class Profiles
      def initialize(client)
        @client = client
      end

      def create(role:, collected_data: {})
        @client.post("/profiles", role: role, collected_data: collected_data)
      end

      def list
        @client.get("/profiles")
      end

      def find(id)
        profile = @client.get("/profiles/#{id}")
        ::Passfort::Resource::Profile.new(profile)
      end
    end
  end
end
