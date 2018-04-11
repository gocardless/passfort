# frozen_string_literal: true

require "passfort/http"

module Passfort
  class Client
    def initialize(api_key:, excon_opts: {})
      @http = Passfort::Http.new(api_key, excon_opts)
    end

    def profiles
      Endpoint::Profiles.new(@http)
    end

    def checks
      Endpoint::Checks.new(@http)
    end

    def tasks
      Endpoint::Tasks.new(@http)
    end

    def company_search(country, query, state = nil, provider = nil)
      search_query = "/search/companies?country=#{CGI.escape(country)}"
      search_query += "&query=#{CGI.escape(query)}"
      search_query += "&state=#{CGI.escape(state)}" unless state.nil?
      search_query += "&provider=#{CGI.escape(provider)}" unless provider.nil?

      response = @http.get(search_query)
      response["companies"].map do |company|
        Passfort::Resource::CompanySummary.new(company)
      end
    end
  end
end
