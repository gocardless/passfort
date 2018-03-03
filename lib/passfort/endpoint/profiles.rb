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
        resource_class(collected_data["entity_type"]).new(collected_data)
      end

      def update_collected_data(id, data)
        collected_data = @client.post("/profiles/#{id}/collected_data", body: data)
        resource_class(collected_data["entity_type"]).new(collected_data)
      end

      private

      def resource_class(entity_type)
        case entity_type
        when Passfort::EntityType::COMPANY then ::Passfort::Resource::CompanyData
        when Passfort::EntityType::INDIVIDUAL then ::Passfort::Resource::IndividualData
        else raise ArgumentError, "Invalid entity type #{entity_type.inspect}"
        end
      end
    end
  end
end
