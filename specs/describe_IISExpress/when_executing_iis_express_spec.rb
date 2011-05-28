require "./lib/command_shell.rb"
require "./lib/iis_express.rb"

describe "when executing iis express" do
  before(:each) do
    File.stub!(:exists?).with(@iis_express.execution_path).and_return(true)
    @sh = mock("CommandShell")
    CommandShell.stub!(:new).and_return(@sh)
    @iis_express = IISExpress.new
  end

  it "provides iis express command for directory and port" do
    path = "c:\\iisexpress\\website"
    port = 80
    @iis_express.command(path, port).should == "\"#{ @iis_express.execution_path }\" /path:"
  end

  context "iis express directory doesn't exist" do
    before(:each) { File.stub!(:exists?).with(@iis_express.execution_path).and_return(false) }

    it "throws error if iisexpress.exe is not found" do
      expect { @iis_express.start }.to raise_error RuntimeError, /unable to find iis express/
    end
  end
end
