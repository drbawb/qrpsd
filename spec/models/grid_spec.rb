require 'spec_helper'

describe Grid do
  describe "tablerefresh" do
    it "should contain normal token and not base token" do
      @base_token = stub_model(Token, :grid => @grid, :grid_id => @grid)
      @normal_token = stub_model(Token, :grid => @grid, :grid_id => @grid, :tblrow => 3, :tblcol => 4)
      @grid = stub_model(Grid, :tokens => [@base_token,@normal_token])

      result = JSON.parse(@grid.tablerefresh)
      result.each do |parse_tok|
        parse_tok['id'].should_not be @base_token.id
      end
    end
  end
  describe "unplaced" do
    it "should return only a base token" do
      @char = stub_model(Character)
      @base_token = stub_model(Token, :grid => @grid, :grid_id => @grid, :character => @char)
      @normal_token = stub_model(Token, :grid => @grid, :grid_id => @grid, :tblrow => 3, :tblcol => 4, :character => @char)
      @grid = stub_model(Grid, :tokens => [@base_token,@normal_token])
      
      @grid.unplaced.each do |parse_tok|
        parse_tok[:id].should_not == @normal_token.id
      end
    end
  end

  describe "placed" do
    it "should return only a placed token in the giant-as-all-get-out array" do
      # Revisiting this code has made me realize that there is [most likely] a superior way to do this
      # Count on this code being refactored, possibly removed. It's kinda clunky and unnecessary.
      # See github/drbawb/qrpsd/wiki/Placed for more info
      @char = stub_model(Character)
      @base_token = stub_model(Token, :grid => @grid, :grid_id => @grid, :character => @char)
      @normal_token = stub_model(Token, :grid => @grid, :grid_id => @grid, :tblrow => 3, :tblcol => 4, :character => @char)
      @grid = stub_model(Grid, :tokens => [@base_token,@normal_token])
      
      ## Code has been refactored to use a hash
      placed = @grid.placed
      placed["#{@normal_token.tblrow}_#{@normal_token.tblcol}"].should_not be_nil
      placed["#{@base_token.tblrow}_#{@base_token.tblcol}"].should be_nil
      
      #placed = @grid.placed.flatten
      #placed.include?("#{@normal_token.tblrow}_#{@normal_token.tblcol}").should be_true
      #placed.include?("#{@base_token.tblrow}_#{@base_token.tblcol}").should be_false
    end
  end
end