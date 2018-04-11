# frozen_string_literal: true

module Passfort
  module Resource
    class CompanySummary < Base
      attributes :name, :number, :country, :state
    end
  end
end
