# frozen_string_literal: true

require "spec_helper"

RSpec.describe Passfort::Endpoint::Tasks do
  let(:endpoint) { described_class.new(client) }

  let(:client) { Passfort::Http.new("api_key", connection: connection) }
  let(:connection) { Excon.new("http://localhost", mock: true) }

  describe "#find" do
    subject { endpoint.find(profile_id: profile_id, task_id: task_id) }

    let(:profile_id) { "a_profile_id" }
    let(:task_id) { "a_task_id" }
    let(:response) { load_fixture("task.json") }

    before do
      Excon.stub(
        { method: :get, path: "/4.0/profiles/#{profile_id}/tasks/#{task_id}" },
        status: 200, body: response,
      )
    end

    it { is_expected.to have_attributes(id: "33cdc540-61e0-11e7-b07b-acbc32b67d7b") }
  end
end
