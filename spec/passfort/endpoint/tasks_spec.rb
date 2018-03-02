# frozen_string_literal: true

require "spec_helper"

RSpec.describe Passfort::Endpoint::Tasks do
  let(:endpoint) { described_class.new(Passfort::Http.new("api_key")) }

  describe "#find" do
    subject { endpoint.find(profile_id: profile_id, task_id: task_id) }

    let(:profile_id) { "a_profile_id" }
    let(:task_id) { "a_task_id" }

    before do
      stub_request(:get, %r{/profiles/#{profile_id}/tasks/#{task_id}\z}).
        to_return(status: 200, body: load_fixture("task.json"))
    end

    it { is_expected.to have_attributes(id: "33cdc540-61e0-11e7-b07b-acbc32b67d7b") }
  end
end
