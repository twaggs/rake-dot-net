require "./lib/command_shell.rb"
require "./lib/web_builder.rb"

describe "when executing build" do
  before(:each) do
    Dir.stub!(:pwd).and_return("z:\\dev")
    Dir.stub!(:glob).and_return([])
    FileUtils.stub!(:rm_rf)
    @command_shell = mock("CommandShell")
    CommandShell.stub!(:new).and_return(@command_shell)
    @builder = WebBuilder.new 
  end

  describe "for source directory" do
    before(:each) do
      @source = "c:/development/foo"
    end

    it "checks file system for directory" do
      File.should_receive(:directory?).with(@source)
      
      @builder.source? @source
    end

    it "returns true if file exists" do
      File.stub!(:directory?).with(@source).and_return(true)

      @builder.source?(@source).should == true
    end
  end

  context "source directory is valid" do
    before(:each) do
      @source = "c:\\development\\foo"
      @destination = "c:\\inetpub\\wwwroot"
      @builder.stub!(:command).and_return("build command")
      @command_shell.stub(:execute)
      File.stub!(:directory?).with(@source).and_return(true)
    end
    
    it "deletes destination directory" do
      FileUtils.should_receive(:rm_rf).with(@destination)

      build
    end

    it "executes build command" do
      @command_shell.should_receive(:execute).with("build command")

      build
    end

    context "delete_after files specified" do
      before(:each) { @delete_after = ["FakeMail", "AppData"] }

      it "deletes each file (or directory) specified" do
        FileUtils.should_receive(:rm_rf).with(File.join(@destination, "FakeMail"))
        FileUtils.should_receive(:rm_rf).with(File.join(@destination, "AppData"))

        build
      end
    end

    context ".csproj file exists in output directory" do
      before(:each) do
        Dir.stub!(:glob).with(File.join(@destination, "*.csproj*")).and_return(["Web.csproj", "Web.csproj.bak", "Web.csproj.user"])
      end

      it "returns the project file" do
        @builder.project_files(@destination).should == ["Web.csproj", "Web.csproj.bak", "Web.csproj.user"]
      end

      it "removes cs proj files from the destination directory" do
        FileUtils.should_receive(:rm).with(["Web.csproj", "Web.csproj.bak", "Web.csproj.user"])

        build
      end
    end

    it "removed Properties directory" do
      FileUtils.should_receive(:rm_rf).with(File.join(@destination, "Properties"))

      build
    end
  end

  context "source directory invalid" do
    before(:each) { @builder.stub!(:source?).and_return(false) }

    it "throws error if source is invalid" do
      @builder.should_receive(:source?)

      expect { build }.to raise_error RuntimeError, /source.*doesn't exist/
    end
  end

  def build 
    @builder.build(@source, @destination, @delete_after)
  end
end
