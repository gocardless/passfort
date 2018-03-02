# frozen_string_literal: true

require "spec_helper"

RSpec.describe Passfort::Endpoint::Checks do
  let(:endpoint) { described_class.new(Passfort::Http.new("api_key")) }

  describe "#create" do
    subject { endpoint.create(profile_id: profile_id, check_type: check_type) }

    let(:profile_id) { "a_profile_id" }
    let(:check_type) { "a_check_type" }

    before do
      stub_request(:post, %r{/profiles/#{profile_id}/checks\z}).
        with(body: { check_type: check_type }).
        to_return(status: 200, body: load_fixture("check.json"))
    end

    it { is_expected.to have_attributes(id: "6c1d594a-496e-11e7-911e-acbc32b67d7b") }
  end
end
