require 'spec_helper'

describe Roll do
  it "should save with a character" do
    @char = mock_model(Character, :name => "ballsman")    
    roll = Roll.new(:query => "[1d4]")
    roll.save.should == false

    roll.character = @char
    roll.save.should == true
  end

  it "should have a resultarray after saving" do
    @char = mock_model(Character, :name => "ballsman")
    roll = Roll.new(:query => "[1d4]", :character => @char)
    roll.resultarray.nil?.should == true
    
    roll.save
    roll.resultarray.nil?.should == false
  end

  it "should parse the following" do
    @char = mock_model(Character, :name => "ballsman")
    roll = Roll.new(:query => "[1d4] is test_type + [1d8] + 4 is test_static + 8", :character => @char)
    roll.parse_query(roll.query).length.should == 4
  end
  
  it "should have results from the following" do
    #Expected syntax: "[1d4] is type + [1d8] + 4 is type + 8"
    #Expected output: 4 dice objects
    @char = mock_model(Character, :name => "ballsman")
    roll = Roll.new(:query => "[1d4] is type + [1d8] + 4 is type + 8", :character => @char)
    roll.save.should == true
    roll.resultarray.length.should == 4
  end

  it "should not save a bad query" do
    @char = mock_model(Character, :name => "test_character")
    roll = Roll.new(:query => "[[1d4]]", :character => @char)
    roll.valid?.should == false
  end
end
