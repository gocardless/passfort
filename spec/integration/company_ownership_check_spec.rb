# frozen_string_literal: true

require "spec_helper"

# https://www.passfort.com/developer/recipes/running-a-company-ownership-check
# rubocop:disable RSpec/DescribeClass
# rubocop:disable RSpec/ExampleLength
RSpec.describe "running a company ownership check" do
  let(:api_key) { "api_key" }
  let(:client) { Passfort::Client.new(api_key: api_key) }

  let(:profile_fixture) { load_fixture("company_ownership_check/profile.json") }
  let(:check_fixture) { load_fixture("company_ownership_check/check.json") }
  let(:collected_data_fixture) do
    load_fixture("company_ownership_check/collected_data.json")
  end
  let(:collected_data_update_fixture) do
    load_fixture("company_ownership_check/collected_data_update_request.json")
  end

  let(:profile_id) { JSON.parse(profile_fixture)["id"] }
  let(:create_profile_args) do
    {
      role: Passfort::Role::COMPANY_CUSTOMER,
      collected_data: {
        entity_type: Passfort::EntityType::COMPANY,
        metadata: {
          country_of_incorporation: "GBR",
          number: "09565115",
        },
      },
    }
  end

  before do
    stub_request(:post, %r{/profiles\z}).
      with(body: create_profile_args).
      to_return(status: 201, body: profile_fixture)
    stub_request(:post, %r{/profiles/#{profile_id}/checks\z}).
      with(body: { check_type: "COMPANY_OWNERSHIP" }).
      to_return(status: 201, body: check_fixture)
    stub_request(:get, %r{/profiles/#{profile_id}/collected_data\z}).
      to_return(
        status: 200,
        body: collected_data_fixture,
      )
    stub_request(:post, %r{/profiles/#{profile_id}/collected_data\z}).
      with(body: JSON.parse(collected_data_update_fixture)).
      to_return(
        status: 200,
        body: collected_data_fixture,
      )
  end

  it "succeeds" do
    profile = client.profiles.create(create_profile_args)

    expect(profile.id).to eq(profile_id)

    check = client.checks.create(profile_id: profile.id, check_type: "COMPANY_OWNERSHIP")

    shareholders = check.output_data["ownership_structure"]["shareholders"]
    beneficial_owners = shareholders.select { |sh| sh["total_percentage"] >= 25 }

    collected_data = client.profiles.collected_data(profile.id).to_h

    collected_data["ownership_structure"] ||= {}
    collected_data["ownership_structure"]["shareholders"] = beneficial_owners

    client.profiles.update_collected_data(profile.id, collected_data)
  end
end
# rubocop:enable RSpec/DescribeClass
# rubocop:enable RSpec/ExampleLength
