require File.dirname(__FILE__) + '/../spec_helper'

describe TagList do
  before(:each) do
    @tag_list = TagList.new("awesome","radical")
  end
  
  it "should be an array" do
    @tag_list.is_a?(Array).should be_true
  end
  
  it "should be able to be add a new tag word" do
    @tag_list.add("cool")
    @tag_list.include?("cool").should be_true
  end
  
  it "should be able to add delimited lists of words" do
    @tag_list.add("cool, wicked", :parse => true)
    @tag_list.include?("cool").should be_true
    @tag_list.include?("wicked").should be_true
  end
  
  it "should be able to remove words" do
    @tag_list.remove("awesome")
    @tag_list.include?("awesome").should be_false
  end
  
  it "should be able to remove delimited lists of words" do
    @tag_list.remove("awesome, radical", :parse => true)
    @tag_list.should be_empty
  end
  
  it "should give a delimited list of words when converted to string" do
    @tag_list.to_s.should == "awesome, radical"
  end
  
  it "should quote escape tags with commas in them" do
    @tag_list.add("cool","rad,bodacious")
    @tag_list.to_s.should == "awesome, radical, cool, \"rad,bodacious\""
  end
end