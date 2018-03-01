# frozen_string_literal: true

module Passfort
  module Resource
    class Task < Base
      attributes :id, :type, :is_complete, :is_expired, :check_ids
    end
  end
end
