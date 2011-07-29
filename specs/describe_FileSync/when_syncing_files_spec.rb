describe FileSync do
  before(:each) { @file_sync = FileSync.new }

  describe "target and destination directory or provided" do
    before(:each) do
      @file_sync.source = "Web"
      @file_sync.destination = "c:/iisexpress/website"
    end

    it "determines destination file name" do
      @file_sync.destination_file_name_for("Web/index.cshtml").should == "c:/iisexpress/website/index.cshtml"
    end

    it "determining destination file is case insensitive" do
      @file_sync.destination_file_name_for("web/index.cshtml").should == "c:/iisexpress/website/index.cshtml"
    end

    context "destination file name contains directory name else where" do
      it "only replaces the root directory" do
        @file_sync.destination_file_name_for("Web/Web.cshtml").should == "c:/iisexpress/website/Web.cshtml"
      end
    end

    context "performing copy" do
      before(:each) do
        FileUtils.stub(:mkdir_p)
        FileUtils.stub(:cp)
      end

      it "copies file from source directory to destination" do
        FileUtils.should_receive(:mkdir_p).with("c:/iisexpress/website/content")
        FileUtils.should_receive(:cp).with("Web/content/jquery.js", "c:/iisexpress/website/content/jquery.js")
      end

      after(:each) do
        @file_sync.sync "Web/content/jquery.js"
      end
    end
  end
end
