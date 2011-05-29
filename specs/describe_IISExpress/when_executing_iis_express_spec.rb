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

  it "starts iis" do
    @sh.should_receive(:execute).with(@iis_express.command(@path, @port))

    @iis_express.start(@path, @port)
  end

  context "iis express directory doesn't exist" do
    before(:each) { File.stub!(:exists?).with(@iis_express.execution_path).and_return(false) }

    it "throws error if iisexpress.exe is not found" do
      expect { @iis_express.start(@path, @port) }.to raise_error RuntimeError, /unable to find iis express/
    end
  end
end
