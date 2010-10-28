require 'spec_helper'

describe Ability do
  ## Admin test-case. Admins are like the *nix "root" user; they can do everything.
  it "should let an admin manage all" do
    @user = mock_model(User, :username => "blargh", :role => "admin")
    a = Ability.new(@user)
    a.can?(:manage, :all).should be_true
  end

  ## Campaigns
  it "should let a user create a campaign" do
    @user = mock_model(User, :username => "blargh", :role => "user")
    a = Ability.new(@user)
    a.can?(:create, Campaign)
  end

  it "should let a GM (user) their own campaign" do
    @user = mock_model(User, :username => "blargh", :role => "user")
    @camp = mock_model(Campaign, :name => "test campaign", :user_id => @user.id)
    
    a = Ability.new(@user)
    a.can?(:manage, @camp).should be_true
  end

  it "should not let a user manage another campaign" do
    @user = mock_model(User, :username => "blargh", :role => "user")
    @user_2 = mock_model(User, :username => "blargh2", :role => "user")
    @camp = mock_model(Campaign, :name => "test campaign", :user_id => @user.id)

    a = Ability.new(@user_2)
    a.can?(:manage, @camp).should be_false
  end

  ## Characters
  it "should let owner of a campaign manage another character" do
    @user = mock_model(User, :username => "campaign_owner", :role => "user")
    @camp = mock_model(Campaign, :name => "testing_camp", :user_id => @user.id)

    @user_2 = mock_model(User, :username => "player", :role => "user")
    @char = mock_model(Character, :user_id => @user_2.id, :campaign => @camp, :name => "characterman")

    a = Ability.new(@user)
    a.can?(:manage, @char).should be_true
  end
  it "should let a user create a character" do
    @user = mock_model(User, :username => "blargh", :role => "user")
    a = Ability.new(@user)
    a.can?(:create, Character).should be_true
  end

  it "should let a user manage their character" do
    @user = mock_model(User, :username => "blargh", :role => "user")
    @char = mock_model(Character, :name => "bunbun", :user_id => @user.id)

    a = Ability.new(@user)
    a.can?(:manage, @char).should be_true
  end

  it "should not let a user manage another user's character" do
    @user = mock_model(User, :username => "blargh", :role => "user")
    @user_2 = mock_model(User, :username => "not_blargh", :role => "user")

    @camp = mock_model(Campaign, :name => "test", :user_id => @user.id)
    @char = mock_model(Character, :name => "bunbun", :user_id => @user.id, :campaign => @camp)

    a = Ability.new(@user_2)
    a.can?(:manage, @char).should be_false
  end

  ## Grids
  it "should be readable only by members/gm of a campaign" do
    @gm = mock_model(User, :role => "user") #Game Master
    @camp = mock_model(Campaign, :user => @gm, :user_id => @gm.id) #Campaign owned by game_master
    @grid = mock_model(Grid, :campaign => @camp) #Grid belongs to campaign

    @user_in = mock_model(User, :username => "innie", :role => "user") #User in campaign
    @user_out = mock_model(User, :username => "outie", :role => "user") #User not in campaign
    @camp.stub!(:users).and_return([@user_in])
    
    a1 = Ability.new(@user_in)
    a2 = Ability.new(@user_out)
    a3 = Ability.new(@gm)
    a1.can?(:read, @grid).should be_true
    a2.can?(:read, @grid).should be_false
    a3.can?(:read, @grid).should be_true
  end

  it "should be updatable by members/gm of a campaign" do
    @gm = mock_model(User, :role => "user") #Game Master
    @camp = mock_model(Campaign, :user => @gm, :user_id => @gm.id) #Campaign owned by game_master
    @grid = mock_model(Grid, :campaign => @camp) #Grid belongs to campaign

    @user_in = mock_model(User, :username => "innie", :role => "user") #User in campaign
    @user_out = mock_model(User, :username => "outie", :role => "user") #User not in campaign
    @camp.stub!(:users).and_return([@user_in])

    a1 = Ability.new(@user_in)
    a2 = Ability.new(@user_out)
    a3 = Ability.new(@gm)
    a1.can?(:update, @grid).should be_true
    a2.can?(:update, @grid).should be_false
    a3.can?(:update, @grid).should be_true
  end
  ## Rolls
  it "should be creatable by a normal user with a character" do
    @user = mock_model(User, :role => "user")
    @character = mock_model(Character, :user_id => @user.id, :user => @user)

    a = Ability.new(@user)
    a.can?(:create, Roll)
  end


  ## Sheets

  ## Skills

  ## Tokens
    it "should only move if the user owns it, or gm owns it by proxy" do
      @gm = mock_model(User, :role => "user")
      @camp = mock_model(Campaign, :user_id => @gm.id, :user => @gm)

      @user = mock_model(User, :role => "user")
      @char = mock_model(Character, :user_id => @user.id, :user => @user, :campaign => @camp)
      @grid = mock_model(Grid, :campaign => @camp, :campaign_id => @camp.id)
      @token = mock_model(Token, :tblrow => 2, :tblcol => 3, :character => @char)
      @user_out = mock_model(User, :role => "user")

      a = Ability.new(@user)
      a2 = Ability.new(@gm)
      a3 = Ability.new(@user_out)

      a.can?(:update, @token).should be_true
      a2.can?(:update, @token).should be_true
      a3.can?(:update, @token).should be_false
    end
  ## Users
end
