# frozen_string_literal: true

require "spec_helper"

RSpec.describe Passfort::Endpoint::Profiles do
  let(:endpoint) { described_class.new(client) }

  let(:client) { Passfort::Http.new("api_key", connection: connection) }
  let(:connection) { Excon.new("http://localhost", mock: true) }

  describe "#create" do
    subject { endpoint.create(role: role, collected_data: collected_data) }

    let(:role) { "a_role" }
    let(:collected_data) { {} }
    let(:expected_request_body) { { role: role, collected_data: collected_data }.to_json }
    let(:response) { load_fixture("profile.json") }

    before do
      Excon.stub(
        { method: :post, path: "/4.0/profiles", body: expected_request_body },
        status: 200, body: response,
      )
    end

    it { is_expected.to have_attributes(id: "b82b0434-f9e8-11e7-8397-000000000000") }
  end

  describe "#find" do
    subject { endpoint.find(id) }

    let(:id) { "b82b0434-f9e8-11e7-8397-000000000000" }
    let(:response) { load_fixture("profile.json") }

    before do
      Excon.stub(
        { method: :get, path: "/4.0/profiles/#{id}" },
        status: 200, body: response,
      )
    end

    it { is_expected.to have_attributes(id: id) }
  end
end
