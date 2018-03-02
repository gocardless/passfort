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

      def collected_data(id)
        collected_data = @client.get("/profiles/#{id}/collected_data")
        # TODO: this can be either individual or company
        ::Passfort::Resource::CompanyData.new(collected_data)
      end

      def update_collected_data(id, data)
        collected_data = @client.post("/profiles/#{id}/collected_data", body: data)
        # TODO: this can be either individual or company
        ::Passfort::Resource::CompanyData.new(collected_data)
      end
    end
  end
end
