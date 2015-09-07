require "coveralls"
Coveralls.wear!

require "take_care"

Dir["./spec/support/**/*.rb"].sort.each {|f| require f}

RSpec.configure do |config|
  config.mock_with :rspec
end
