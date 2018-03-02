# frozen_string_literal: true

require "spec_helper"

RSpec.describe Passfort::Endpoint::Profiles do
  let(:endpoint) { described_class.new(Passfort::Http.new("api_key")) }

  describe "#create" do
    subject { endpoint.create(role: role, collected_data: collected_data) }

    let(:role) { "a_role" }
    let(:collected_data) { {} }

    before do
      stub_request(:post, %r{/profiles\z}).
        with(body: { role: role, collected_data: collected_data }).
        to_return(status: 200, body: load_fixture("profile.json"))
    end

    it { is_expected.to have_attributes(id: "b82b0434-f9e8-11e7-8397-000000000000") }
  end

  describe "#find" do
    subject { endpoint.find(id) }

    let(:id) { "b82b0434-f9e8-11e7-8397-000000000000" }

    before do
      stub_request(:get, %r{/profiles/#{id}}).
        to_return(status: 200, body: load_fixture("profile.json"))
    end

    it { is_expected.to have_attributes(id: id) }
  end
end
