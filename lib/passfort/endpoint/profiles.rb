# frozen_string_literal: true

require "passfort/resource/profile"

module Passfort
  module Endpoint
    class Profiles
      def initialize(client)
        @client = client
      end

      def create(role:, collected_data: {})
        profile = @client.post(
          "/profiles",
          body: { role: role, collected_data: collected_data },
        )
        ::Passfort::Resource::Profile.new(profile)
      end

      def find(id)
        profile = @client.get("/profiles/#{id}")
        ::Passfort::Resource::Profile.new(profile)
      end
    end
  end
end
