require "./lib/command_shell.rb"
require "./lib/sln_builder.rb"

describe "when building solution" do
  before(:each) do 
    @sh = mock("CommandShell")
    @sh.stub!(:execute)
    CommandShell.stub!(:new).and_return(@sh)
    Dir.stub!(:glob).and_return([])
    Dir.stub!(:glob).with("**/bin").and_return(["Web/bin", "Model/bin"])
    Dir.stub!(:glob).with("**/obj").and_return(["Web/obj", "Model/obj"])
    FileUtils.stub!(:rm_rf)
    @sln = SlnBuilder.new 
    @solutionFile = "SomeSolution.sln"
  end

  it "sets the build command for a solution" do
    @sln.command(@solutionFile).should == "\"#{@sln.msbuild_path}\" \"#{@solutionFile}\" /verbosity:quiet /nologo"
  end

  it "build solution" do
    @sh.should_receive(:execute).with(@sln.command(@solutionFile))

    build
  end

  it "finds all bin directories" do
    @sln.bins.should == ["Web/bin", "Model/bin"]
  end

  it "finds all obj directories" do
    @sln.objs.should == ["Web/obj", "Model/obj"]
  end

  it "deletes all bin directories" do
    FileUtils.should_receive(:rm_rf).with("Web/bin")
    FileUtils.should_receive(:rm_rf).with("Model/bin")
    build
  end

  it "deletes all obj directories" do
    FileUtils.should_receive(:rm_rf).with("Web/obj")
    FileUtils.should_receive(:rm_rf).with("Model/obj")
    build
  end

  def build
    @sln.build(@solutionFile)
  end
end
