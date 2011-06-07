require './lib/iis_express.rb'

describe "when executing iis express" do
  before(:each) do
    @sh = mock("CommandShell")
    CommandShell.stub!(:new).and_return(@sh)
    @iis_express = IISExpress.new
    File.stub!(:exists?).with(@iis_express.execution_path).and_return(true)
    @path = "c:\\iisexpress\\website"
    @port = 80
  end

  it "provides iis express command for directory and port" do
    @iis_express.command(@path, @port).should == "start /d\"#{ @iis_express.execution_path }\" /MIN iisexpress /path:\"#{ @path }\" /port:#{ @port }"
  end
end
