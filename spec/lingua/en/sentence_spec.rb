require File.dirname(__FILE__) + "/../../spec_helper"

describe Lingua::EN::Sentence do
  klass = Lingua::EN::Sentence

  describe "#sentences" do
    describe "quoted sentences" do
      before(:each) do
        text = "As Milton Bradley once said, \"board games are the shit.\" And I'm inclined to agree. \"Why can't we be friends?\""
        @sentences = klass.sentences(text)
      end

      it "should get the correct number of sentences" do
        @sentences.should have(3).things
      end

      it "should get the correct sentences" do
        @sentences[0].should == "As Milton Bradley once said, \"board games are the shit.\""
        @sentences[1].should == "And I'm inclined to agree."
        @sentences[2].should == "\"Why can't we be friends?\""
      end
    end

    describe "ellipses correction" do
      before(:each) do
        text = "Well... why would you do that? Let's not fight."
        @sentences = klass.sentences(text)
      end

      it "should get the correct number of sentences" do
        @sentences.should have(2).things
      end

      it "should get the right sentences" do
        @sentences[0].should == "Well... why would you do that?"
        @sentences[1].should == "Let's not fight."
      end
    end

    describe "simple URL matching" do
      before(:each) do
        text = "Hello, visit http://www.google.com/index.php?ok=ok for more info. Ok?"
        @sentences = klass.sentences(text)
      end

      it "should get the correct number of sentences" do
        @sentences.should have(2).things
      end

      it "should get the right sentences" do
        @sentences[0].should == "Hello, visit http://www.google.com/index.php?ok=ok for more info."
        @sentences[1].should == "Ok?"
      end
    end

    describe "ending a sentence with an abbreviation" do
      before(:each) do
        text = "I was born in the U.S.S.R. My parents were from the U.S. This is not weird."
        @sentences = klass.sentences(text)
      end

      it "should get the correct number of sentences" do
        @sentences.should have(3).things
      end

      it "should get the correct sentences" do
        @sentences[0].should == "I was born in the U.S.S.R."
        @sentences[1].should == "My parents were from the U.S."
        @sentences[2].should == "This is not weird."
      end
    end

    describe "basic sentences" do
      before(:each) do
        text = "Hello, my name is David. What is your name?"
        @sentences = klass.sentences(text)
      end

      it "should get the correct number of sentences" do
        @sentences.should have(2).things
      end
    end

    describe "sentences with URLs and abbreviation" do
      before(:each) do
        text = "Many of these leading names now have their own website, e.g.  http://www.kaptest.com/. Hello, e.g. you don't know what you mean. I'm so angry about what you said about the U.S.A. or the u.S. or the U.S.S.R. ok."
        @sentences = klass.sentences(text)
      end

      it "should get the correct number of sentences" do
        @sentences[0].should == "Many of these leading names now have their own website, e.g.  http://www.kaptest.com/."
        @sentences[1].should == "Hello, e.g. you don't know what you mean."
        @sentences[2].should == "I'm so angry about what you said about the U.S.A. or the u.S. or the U.S.S.R. ok."
        @sentences.should have(3).things
      end
    end
  end

  describe "#abbreviation" do
    it "should change the abbreviations list" do
      klass.abbreviation('monkey', 'pig')
      klass.abbreviations.should include('monkey')
      klass.abbreviations.should include('pig')
    end

    it "should change the regex for abbreviations" do
      lambda {
        klass.abbreviation('monkey')
      }.should change(klass, :abbr_regex)
    end

    after(:each) do
      klass.initialize_abbreviations!
    end
  end
end
