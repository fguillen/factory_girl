require "spec_helper"

describe "declaring attributes on a Factory that are private methods on Object" do
  before do
    define_model("Website", :system => :boolean, :link => :string, :sleep => :integer)

    FactoryGirl.define do
      factory :website do
        system false
        link   "http://example.com"
        sleep  15
      end
    end
  end

  subject { FactoryGirl.build(:website, :sleep => -5) }

  its(:system) { should == false }
  its(:link)   { should == "http://example.com" }
  its(:sleep)  { should == -5 }
end

describe "using attributes on a Factory that are private methods on Object but wihout assigning a default value in factory" do
  before do
    define_model("Image", :format => :string)

    FactoryGirl.define do
      factory :image do
      end
    end
  end

  subject { FactoryGirl.build(:image, :format => "the format") }

  its(:format)  { should == "the format" }
end

