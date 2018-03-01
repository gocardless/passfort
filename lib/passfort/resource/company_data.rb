# frozen_string_literal: true

module Passfort
  module Resource
    class CompanyData < Base
      def self.attributes
        %i[
          entity_type metadata authorized_persons unauthorized_persons ownership_structure
          officers filings customer_ref external_refs
        ]
      end
    end
  end
end
