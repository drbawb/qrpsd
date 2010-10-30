require 'spec_helper'
include Devise::TestHelpers # to give your spec access to helpers

describe TokensController do
  before(:each) do
    @test_user = Factory.create(:user, :email => "mrweird@weird.com")
    #@mock_user = User.new(:username => "bob", :email => "user@user.com", :password => "shitshitshit")
    #@mock_user.role = "admin"
    sign_in @test_user
    #  include Devise::TestHelpers # to give your spec access to helpersr 
  end
  it "should let me see grids/:g_id/tokens index" do
    campaign = Factory.create(:campaign, :user => @test_user)
    grid = Factory.create(:grid, :campaign => campaign)
    character = Factory.create(:character, :user => @test_user, :campaign => campaign)
    token= Factory.create(:token, :grid => grid, :character => character)
    
    get "index", :grid_id => grid.id
    response.should be_success
  end

  it "should clone a token [new id]" do
    campaign = Factory.create(:campaign, :user => @test_user)
    grid = Factory.create(:grid, :campaign => campaign)
    character = Factory.create(:character, :user => @test_user, :campaign => campaign)
    token= Factory.create(:token, :grid => grid, :character => character)
    
    put :update, :grid_id => grid.id, :id => token.id, :token => {:tblrow => '4', :tblcol => '6'}
    assigns[:token].id.should_not == token.id
  end

  it "should not let turn_order be set by xhr" do
    campaign = Factory.create(:campaign, :user => @test_user)
    grid = Factory.create(:grid, :campaign => campaign)
    character = Factory.create(:character, :user => @test_user, :campaign => campaign)
    token= Factory.create(:token, :grid => grid, :character => character)

    xhr :put, :update, :id => token.id, :grid_id => grid.id, :token => {:tblrow => '4', :tblcol => '6', :turn_order => '1'}
    assigns[:token].turn_order.should be_nil
  end

  it "should let turn_order be set by http" do
    campaign = Factory.create(:campaign, :user => @test_user)
    grid = Factory.create(:grid, :campaign => campaign)
    character = Factory.create(:character, :user => @test_user, :campaign => campaign)
    token= Factory.create(:token, :grid => grid, :character => character)
    put :update, :grid_id => grid.id, :id => token.id, :token => {:tblrow => '4', :tblcol => '6', :turn_order => '1'}
    assigns[:token].turn_order.should == 1
  end
end 
