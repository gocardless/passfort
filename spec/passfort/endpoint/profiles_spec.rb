# frozen_string_literal: true

require "spec_helper"

RSpec.describe Passfort::Endpoint::Profiles do
  let(:profiles) { described_class.new(client) }

  let(:client) { instance_double(Passfort::Http) }

  let(:profile_fixture) { JSON.parse(load_fixture("profile.json")) }
  let(:collected_data_fixture) { JSON.parse(load_fixture("collected_data.json")) }

  describe "#create" do
    subject { profiles.create(role: role, collected_data: collected_data) }

    let(:role) { Passfort::Role::COMPANY_CUSTOMER }
    let(:collected_data) { {} }

    before do
      allow(client).
        to receive(:post).
        with("/profiles", body: { role: role, collected_data: collected_data }).
        and_return(profile_fixture)
    end

    it { is_expected.to have_attributes(id: profile_fixture["id"]) }
  end

  describe "#find" do
    subject { profiles.find(id) }

    let(:id) { profile_fixture["id"] }

    before do
      allow(client).to receive(:get).with("/profiles/#{id}").and_return(profile_fixture)
    end

    it { is_expected.to have_attributes(id: id) }
  end

  describe "#collected_data" do
    subject { profiles.collected_data(id) }

    let(:id) { profile_fixture["id"] }

    before do
      allow(client).
        to receive(:get).
        with("/profiles/#{id}/collected_data").
        and_return(collected_data_fixture)
    end

    it { is_expected.to have_attributes(entity_type: Passfort::EntityType::COMPANY) }
    it { is_expected.to be_a(Passfort::Resource::CompanyData) }
  end

  describe "#update_collected_data" do
    subject(:update_collected_data) { profiles.update_collected_data(id, data) }

    let(:id) { profile_fixture["id"] }
    let(:data) do
      collected_data_fixture.merge(metadata: { country_of_incorporation: "FR" })
    end

    before do
      allow(client).
        to receive(:post).
        with("/profiles/#{id}/collected_data", body: data).
        and_return(data)
    end

    it do
      expect(update_collected_data).to have_attributes(
        entity_type: Passfort::EntityType::COMPANY,
        metadata: { country_of_incorporation: "FR" },
      )
    end
  end
end
