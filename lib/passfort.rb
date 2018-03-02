# frozen_string_literal: true

require "passfort/version"
require "passfort/errors"

require "passfort/resource"
require "passfort/endpoint"
require "passfort/client"

module Passfort
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
