require "./lib/sln_builder.rb"

describe "when intializing solution builder" do
  before(:each) { @sln = SlnBuilder.new }
  it "sets ms build path to v4.0" do
    @sln.msbuild_path.should == "#{ENV['SystemRoot']}\\Microsoft.NET\\Framework\\v4.0.30319\\msbuild.exe"
  end
end
