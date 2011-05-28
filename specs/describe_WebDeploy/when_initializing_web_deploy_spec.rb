require "./lib/command_shell.rb"
require "./lib/web_deploy.rb"

describe "when initializing web deploy" do
  before(:each) do 
    Dir.stub!(:pwd).and_return("c:\\dev")
    @command_shell = mock("CommandShell")
    CommandShell.stub!(:new).and_return(@command_shell)
    @deploy = WebDeploy.new
  end

  it "news up class" do 
    @deploy.nil?.should == false
  end

  it "sets up a default .net 4.0 build path" do
    @deploy.asp_compiler_path.should == "C:\\Windows\\Microsoft.NET\\Framework\\v4.0.30319\\aspnet_compiler.exe"    
  end

  describe "build command" do
    before(:each) do
      @source = "c:\\development\\somesolution\\somemvcapp\\"
      @destination = "c\\develpment\\somesolution\\destination\\"
    end

    it "sets build command using source and desination" do
      @deploy.command(@source, @destination).should == "\"#{@deploy.asp_compiler_path}\" \"#{@destination}\" -u -v \"\/\" -p \"#{@source}\""
    end
  end
end

