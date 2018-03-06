# frozen_string_literal: true

require "passfort/version"
require "passfort/errors"

require "passfort/resource"
require "passfort/endpoint"
require "passfort/client"

module Passfort
  module CheckType
    IDENTITY_CHECK = "IDENTITY_CHECK"
    DOCUMENT_VERIFICATION = "DOCUMENT_VERIFICATION"
    DOCUMENT_FETCH = "DOCUMENT_FETCH"
    PEPS_SCREEN = "PEPS_SCREEN"
    SANCTIONS_SCREEN = "SANCTIONS_SCREEN"
    PEPS_AND_SANCTIONS_SCREEN = "PEPS_AND_SANCTIONS_SCREEN"
    COMPANY_REGISTRY = "COMPANY_REGISTRY"
    COMPANY_OWNERSHIP = "COMPANY_OWNERSHIP"
    COMPANY_FILINGS = "COMPANY_FILINGS"
    COMPANY_FILING_PURCHASE = "COMPANY_FILING_PURCHASE"
    COMPANY_PEPS_AND_SANCTIONS_SCREEN = "COMPANY_PEPS_AND_SANCTIONS_SCREEN"
  end

  module EntityType
    INDIVIDUAL = "INDIVIDUAL"
    COMPANY = "COMPANY"
  end

  module Role
    INDIVIDUAL_CUSTOMER = "INDIVIDUAL_CUSTOMER"
    INDIVIDUAL_ASSOCIATED = "INDIVIDUAL_ASSOCIATED"
    COMPANY_CUSTOMER = "COMPANY_CUSTOMER"
  end
end
