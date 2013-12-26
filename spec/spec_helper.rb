require 'catamaran'

RSpec.configure do |config|
  config.before(:suite) do
  end
 
  config.before(:each) do
    Catamaran::Manager.hard_reset
  end
end