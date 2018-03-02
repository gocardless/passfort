# frozen_string_literal: true

require "passfort"
require "pry"
require "webmock/rspec"

def load_fixture(path)
  File.read(File.join(__dir__, "fixtures", path))
end
