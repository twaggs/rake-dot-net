require "./lib/web_builder.rb"

describe "when initializing web builder" do
  before(:each) do 
    Dir.stub!(:pwd).and_return("c:\\dev")
    @builder = WebBuilder.new
  end

  it "news up class" do 
    @builder.nil?.should == false
  end

  it "sets up a default .net 4.0 build path" do
    @builder.path.should == "C:\\Windows\\Microsoft.NET\\Framework\\v4.0.30319\\aspnet_compiler.exe"    
  end

  it "sets temp directory to process's working directory" do
    @builder.temp.should == "c:\\dev\\temp\\"
  end

  it "sets destination dirctory to default value" do
    @builder.destination.should == "c:\\inetpub\\wwwroot\\"
  end
end

describe "when executing build" do
  before(:each) do
    Dir.stub!(:pwd).and_return("z:\\dev")
    File.stub!(:rm_rf)
    @builder = WebBuilder.new 
  end

  describe "source directory" do
    before(:each) do
      @builder.source = "c:/development/foo"
    end

    it "checks file system for directory" do
      File.should_receive(:directory?).with("c:/development/foo")
      
      @builder.source?
    end

    it "returns true if file exists" do
      File.stub!(:directory?).with(@builder.source).and_return(true)

      @builder.source?.should == true
    end
  end

  context "source directory is valid" do
    before(:each) do
      @builder.source = "c:\\development\\foo"
      File.stub!(:directory?).with(@builder.source).and_return(true)
    end
    
    it "deletes temp directory" do
      File.should_receive(:rm_rf).with(@builder.temp)

      @builder.build
    end

    it "deletes destination directory" do
      @builder.destination = "z:\\inetpub\\wwwroot\\"
      File.should_receive(:rm_rf).with(@builder.destination)

      @builder.build
    end
  end

  context "source directory invalid" do
    before(:each) { @builder.stub!(:source?).and_return(false) }

    it "throws error if source is invalid" do
      @builder.should_receive(:source?)

      expect { @builder.build }.to raise_error RuntimeError, /source.*doesn't exist/
    end
  end
end
