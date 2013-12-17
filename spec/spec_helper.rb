require 'catamaran'

RSpec.configure do |config|
  config.before(:suite) do
  end
 
  config.before(:each) do
    Catamaran::Manager.reset
  end
end