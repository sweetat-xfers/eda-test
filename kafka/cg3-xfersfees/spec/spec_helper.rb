require "racecar"
require "timecop"
require_relative 'support/mock_env'

RSpec.configure do |config|
  config.disable_monkey_patching!
  config.include MockEnv
end

