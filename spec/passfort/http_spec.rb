# frozen_string_literal: true

require "spec_helper"

RSpec.describe Passfort::Http do
  let(:http) { described_class.new("api_key") }
  let(:path) { "a/path" }

  shared_examples "an API call that handles all errors" do
    let(:api_path) { Passfort::Http::DOMAIN + Passfort::Http::ROOT_PATH + path }
    let(:status) { 200 }
    let(:error_code) { 0 }
    let(:body) { { errors: { code: error_code } }.to_json }

    before { stub_request(method, api_path). to_return(status: status, body: body) }

    context "when returning a request error" do
      let(:status) { 404 }
      let(:error_class) { Passfort::Errors::RequestError }

      it "raises a specific APIError" do
        is_expected.to raise_error(instance_of(error_class))
      end
    end

    context "when returning an invalid API Key error" do
      let(:error_code) { 204 }
      let(:error_class) { Passfort::Errors::InvalidAPIKeyError }

      it "raises a specific APIError" do
        is_expected.to raise_error(instance_of(error_class))
      end
    end

    context "when returning an invalid input data error" do
      let(:error_code) { 201 }
      let(:error_class) { Passfort::Errors::InvalidInputDataError }

      it "raises a specific APIError" do
        is_expected.to raise_error(instance_of(error_class))
      end
    end

    context "when returning a chargeable limit reached error" do
      let(:error_code) { 104 }
      let(:error_class) { Passfort::Errors::ChargeableLimitReachedError }

      it "raises a specific APIError" do
        is_expected.to raise_error(instance_of(error_class))
      end
    end

    context "when returning an unknown API error" do
      let(:error_code) { 203 }
      let(:error_class) { Passfort::Errors::APIError }

      it "raises a specific APIError" do
        is_expected.to raise_error(instance_of(error_class))
      end
    end

    context "when returning a successful result" do
      let(:result) { subject.call }

      before do
        stub_request(method, api_path).
          to_return(status: status, body: load_fixture("check.json"))
      end

      it "includes the id response" do
        expect(result).to include("id" => "6c1d594a-496e-11e7-911e-acbc32b67d7b")
      end
    end
  end

  describe "#get" do
    subject { -> { http.get(path) } }

    let(:method) { :get }

    it_behaves_like "an API call that handles all errors"
  end

  describe "#post" do
    subject { -> { http.post(path, body: {}) } }

    let(:method) { :post }

    it_behaves_like "an API call that handles all errors"
  end
end