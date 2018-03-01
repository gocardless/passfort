# frozen_string_literal: true

module Passfort
  module Endpoint
    class Checks
      def initialize(client)
        @client = client
      end

      def create(profile_id:, check_type:)
        response = @client.post(
          "/profiles/#{profile_id}/checks",
          body: { check_type: check_type },
        )
        Passfort::Resource::Check.new(response)
      end
    end
  end
end
