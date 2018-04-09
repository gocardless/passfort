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
  end
end
