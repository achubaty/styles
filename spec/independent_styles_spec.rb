INDEPENDENT_STYLES.each do |path|
  filename = File.basename(path)
  id = filename[0..-5]

  describe id do

    it "is a valid CSL 1.0 style" do
      CSL.validate(path).should == []
    end

    it "has a conventional file name" do
      filename.should match(/[a-z\d](-[a-z\d]+)*\.csl$/)
    end

    describe "the parsed style" do
      before :all do
        @style = CSL::Style.load(path)
      end

      it "was successfully parsed" do
        @style.should be_a(CSL::Style)
      end

      it "has an info element" do
       @style.should have_info
      end

      it "has a self-link" do
        @style.should have_self_link
      end

      it "has an id" do
        @style.info.should have_id
      end

      it "the self-link is a valid style repository link" do
        @style.self_link.should == "http://www.zotero.org/styles/#{id}"
      end

      it "the self-link should match the style id" do
        @style.id.should == @style.self_link
      end

      it "has and info/rights element" do
        @style.info.should have_rights
      end

      it "is licensed under a CC BY-SA license" do
        @style.info.rights.to_s.strip.should ==
          'This work is licensed under a Creative Commons Attribution-ShareAlike 3.0 License: http://creativecommons.org/licenses/by-sa/3.0/'
      end

      it "its template-link (if present) points to an existing independent style" do
        if @style.has_template_link?
          link = @style.template_link

          link.should match(%r{http://www.zotero.org/styles/([a-z-]+)})
          INDEPENDENT_STYLES.grep(/\/#{link[/[^\/]+$/]}\.csl$/).should have(1).elements
        end
      end

    end

  end
end