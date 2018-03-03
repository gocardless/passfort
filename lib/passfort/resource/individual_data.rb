# frozen_string_literal: true

module Passfort
  module Resource
    class IndividualData < Base
      attributes :entity_type, :personal_details, :address_history,
                 :contact_details, :phone_number, :email, :ip_location,
                 :documents
    end
  end
end
