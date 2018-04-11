# frozen_string_literal: true

require "spec_helper"

RSpec.describe Passfort::Client do
  let(:client) { described_class.new(api_key: "api_key") }

  describe "#company_search" do
    let(:result) { client.company_search(country, query, state, provider) }

    let(:country) { "GBR" }
    let(:query) { "GoCard" }
    let(:state) { nil }
    let(:provider) { "duedil" }

    before do
      stub_request(
        :get,
        %r{/search/companies\?country=#{country}&provider=#{provider}&query=#{query}\z},
      ).to_return(status: 200, body: load_fixture("companies.json"))
    end

    it "returns an array of companies" do
      expect(result).to be_a(Array)
    end

    it "returns expected number of companies" do
      expect(result.count).to eq(3)
    end

    it "returns right type of company summary resource" do
      expect(result[0]).to be_a(Passfort::Resource::CompanySummary)
    end

    it "returns maps company summary data" do
      expect(result[0]).to have_attributes(
        country: "GBR",
        name: "GOCARDLESS LTD",
        number: "07495895",
      )
    end
  end
end
