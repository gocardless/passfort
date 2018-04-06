# frozen_string_literal: true

require "spec_helper"
require "timecop"

RSpec.describe Passfort::Http do
  let(:http) { described_class.new("api_key") }
  let(:path) { "a/path" }

  shared_examples "an API call that handles all errors" do
    let(:api_path) { Passfort::Http::DOMAIN + Passfort::Http::ROOT_PATH + path }
    let(:status) { 200 }
    let(:error_code) { 0 }
    let(:body) { { errors: { code: error_code } }.to_json }

    before { stub_request(method, api_path).to_return(status: status, body: body) }

    context "when returning a request error" do
      let(:status) { 404 }
      let(:error_class) { Passfort::Errors::RequestError }

      it { is_expected.to raise_error(error_class) }
    end

    context "when returning an invalid API Key error" do
      let(:error_code) { 204 }
      let(:error_class) { Passfort::Errors::InvalidAPIKeyError }

      it { is_expected.to raise_error(error_class) }
    end

    context "when returning an invalid input data error" do
      let(:error_code) { 201 }
      let(:error_class) { Passfort::Errors::InvalidInputDataError }

      it { is_expected.to raise_error(error_class) }
    end

    context "when returning a chargeable limit reached error" do
      let(:error_code) { 104 }
      let(:error_class) { Passfort::Errors::ChargeableLimitReachedError }

      it { is_expected.to raise_error(error_class) }
    end

    context "when returning an unknown API error" do
      let(:error_code) { 203 }
      let(:error_class) { Passfort::Errors::UnknownApiError }

      it { is_expected.to raise_error(error_class) }
    end

    context "when returning a response that can't be parsed as JSON" do
      let(:body) { "<html><body><h1>something that isn't json</h1></body></html>" }
      let(:error_class) { Passfort::Errors::UnparseableResponseError }

      it { is_expected.to raise_error(error_class) }
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

    context "when the request times out" do
      before { stub_request(method, api_path).to_raise(Excon::Errors::Timeout) }
      let(:error_class) { Passfort::Errors::TimeoutError }

      it { is_expected.to raise_error(error_class) }
    end
  end

  shared_examples_for "an API call that sends notifications" do
    let(:api_path) { Passfort::Http::DOMAIN + Passfort::Http::ROOT_PATH + path }
    let(:notifications) { [] }
    let(:time) { Time.local(1990) }
    let(:payload) { { path: path, response: be_truthy } }
    let(:expected_notification) do
      have_attributes(
        name: "passfort.#{method}",
        transaction_id: match(/\A.{20}\Z/),
        time: time,
        end: time,
        payload: payload,
      )
    end
    let(:result) { subject.call }

    before do
      ActiveSupport::Notifications.subscribe do |*args|
        notifications << ActiveSupport::Notifications::Event.new(*args)
      end
      stub_request(method, api_path).to_return(body: {}.to_json)
      payload[:body] = be_truthy if method == :post
    end

    it "records a notification" do
      Timecop.freeze(time) do
        result
      end
      expect(notifications).to match([expected_notification])
    end
  end

  describe "#get" do
    subject { -> { http.get(path) } }

    let(:method) { :get }

    it_behaves_like "an API call that handles all errors"
    it_behaves_like "an API call that sends notifications"
  end

  describe "#post" do
    subject { -> { http.post(path, body: {}) } }

    let(:method) { :post }

    it_behaves_like "an API call that handles all errors"
    it_behaves_like "an API call that sends notifications"
  end
end
