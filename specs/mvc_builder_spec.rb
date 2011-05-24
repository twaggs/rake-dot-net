describe MvcBuilder do
  it "should new up class" do 
    @builder = MvcBuilder.new()

    @builder.nil?.should == false
  end
end

