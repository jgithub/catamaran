require "spec_helper"

describe Catamaran::Manager do
  context 'by default' do
    describe ".formatter_pattern" do
      it "should be of the format \"%-6p pid-%pid [%d{ISO8601}] %47C - %m\"" do
        Catamaran::Manager.formatter_pattern.should == "%-6p pid-%pid [%d{ISO8601}] %47C - %m"
      end
    end
  end
end
