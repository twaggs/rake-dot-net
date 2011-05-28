require './lib/iis_express.rb'

describe "when initializing iis express" do
  before(:each) { @iis_express = IISExpress.new }

  it "sets iis express execution path" do
    @iis_express.execution_path.should == "C:\\Program Files (x86)\\IIS Express\\iisexpress.exe"
  end
end
