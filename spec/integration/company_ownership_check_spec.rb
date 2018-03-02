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

  it "succeeds" do
    create_profile_args = {
      role: "COMPANY_CUSTOMER",
      collected_data: {
        entity_type: "COMPANY",
        metadata: {
          country_of_incorporation: "GBR",
          number: "09565115",
        },
      },
    }

    stub_request(:post, %r{/profiles\z}).
      with(body: create_profile_args).
      to_return(status: 201, body: profile_fixture)
    profile = client.profiles.create(create_profile_args)

    expect(profile.id).to eq(JSON.parse(profile_fixture)["id"])

    stub_request(:post, %r{/profiles/#{profile.id}/checks\z}).
      with(body: { check_type: "COMPANY_OWNERSHIP" }).
      to_return(status: 201, body: check_fixture)
    check = client.checks.create(profile_id: profile.id, check_type: "COMPANY_OWNERSHIP")

    shareholders = check.output_data["ownership_structure"]["shareholders"]
    beneficial_owners = shareholders.select { |sh| sh["total_percentage"] >= 25 }

    stub_request(:get, %r{/profiles/#{profile.id}/collected_data\z}).
      to_return(
        status: 200,
        body: collected_data_fixture,
      )
    collected_data = client.profiles.collected_data(profile.id).to_h

    collected_data["ownership_structure"] ||= {}
    collected_data["ownership_structure"]["shareholders"] = beneficial_owners

    collected_data_update_request = JSON.parse(collected_data_update_fixture)
    stub_request(:post, %r{/profiles/#{profile.id}/collected_data\z}).
      with(body: collected_data_update_request).
      to_return(
        status: 200,
        body: collected_data_fixture,
      )
    client.profiles.update_collected_data(profile.id, collected_data)
  end
end
# rubocop:enable RSpec/DescribeClass
# rubocop:enable RSpec/ExampleLength
