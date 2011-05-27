require "./lib/command_shell.rb"
require "./lib/web_builder.rb"

describe "when initializing web builder" do
  before(:each) do 
    Dir.stub!(:pwd).and_return("c:\\dev")
    @command_shell = mock("CommandShell")
    CommandShell.stub!(:new).and_return(@command_shell)
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

  describe "build command" do
    before(:each) do
      @builder.source = "c:\\development\\somesolution\\somemvcapp\\"
      @builder.destination = "c\\develpment\\somesolution\\temp\\"
    end

    it "sets build command using source and desination" do
      @builder.build_command(@builder.source, @builder.destination).should == "\"#{@builder.path}\" \"#{@builder.temp}\" -u -v \"\/\" -p \"#{@builder.source}\""
    end
  end
end

describe "when executing build" do
  before(:each) do
    Dir.stub!(:pwd).and_return("z:\\dev")
    Dir.stub!(:glob).and_return([])
    FileUtils.stub!(:rm_rf)
    @command_shell = mock("CommandShell")
    CommandShell.stub!(:new).and_return(@command_shell)
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
      @builder.stub!(:build_command).and_return("build command")
      @command_shell.stub(:execute)
      File.stub!(:directory?).with(@builder.source).and_return(true)
    end
    
    it "deletes temp directory" do
      FileUtils.should_receive(:rm_rf).with(@builder.temp)

      @builder.build
    end

    it "executes build command" do
      @command_shell.should_receive(:execute).with("build command")

      @builder.build
    end

    context "scrub files specified" do
      before(:each) { @builder.scrub = ["FakeMail", "AppData"] }

      it "deletes each file (or directory) specified" do
        FileUtils.should_receive(:rm_rf).with(File.join(@builder.temp, "FakeMail"))
        FileUtils.should_receive(:rm_rf).with(File.join(@builder.temp, "AppData"))

        @builder.build
      end
    end

    context ".csproj file exists in output directory" do
      before(:each) do
        Dir.stub!(:glob).with(File.join(@builder.temp, "*.csproj*")).and_return(["Web.csproj", "Web.csproj.bak", "Web.csproj.user"])
      end

      it "returns the project file" do
        @builder.project_files.should == ["Web.csproj", "Web.csproj.bak", "Web.csproj.user"]
      end

      it "removes cs proj files from the temp directory" do
        FileUtils.should_receive(:rm).with(["Web.csproj", "Web.csproj.bak", "Web.csproj.user"])

        @builder.build
      end
    end

    it "removed Properties directory" do
      FileUtils.should_receive(:rm_rf).with(File.join(@builder.temp, "Properties"))

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
