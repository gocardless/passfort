# frozen_string_literal: true

require "spec_helper"

RSpec.describe Passfort::Endpoint::Checks do
  let(:endpoint) { described_class.new(client) }

  let(:client) { Passfort::Http.new("api_key", connection: connection) }
  let(:connection) { Excon.new("http://localhost", mock: true) }

  describe "#create" do
    subject { endpoint.create(profile_id: profile_id, check_type: check_type) }

    let(:profile_id) { "a_profile_id" }
    let(:check_type) { "a_check_type" }
    let(:expected_request_body) { { check_type: check_type }.to_json }
    let(:response) { load_fixture("check.json") }

    before do
      Excon.stub(
        {
          method: :post,
          path: "/4.0/profiles/#{profile_id}/checks",
          body: expected_request_body,
        },
        status: 200, body: response,
      )
    end

    it { is_expected.to have_attributes(id: "6c1d594a-496e-11e7-911e-acbc32b67d7b") }
  end
end
