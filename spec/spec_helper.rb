# frozen_string_literal: true

require "passfort"
require "pry"

def load_fixture(path)
  File.read(File.join(__dir__, "fixtures", path))
end

RSpec.configure do |config|
  config.after { Excon.stubs.clear }
end
