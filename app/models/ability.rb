class Ability
  include CanCan::Ability
  def initialize(user)
    #user ||= UserSession.new
    if user && user.role == 'admin'
      can :manage, :all
    elsif user && user.role == 'user'
      #User is logged in
      #The user CAN:
      can :index, :all # Everyone can see everything. I may change this later; but for now I don't see anything wrong with it

      #Campaign permissions
      can :manage, Campaign, :user_id => user.id

      can [:new, :create, :show], Campaign

      #Character permissions
      can [:new, :create], Character
      can [:manage], Character do |character|
        #Only a specific user ID can update their character
        if character && character.user_id == user.id
          true
        elsif character && character.campaign.user_id == user.id
          true
        else
          false
        end
      end

      #Grid permissions
      can [:test, :tablerefresh, :update], Grid
      can :read, Grid do |grid|
        (grid.campaign.user_id == user.id) || (grid.campaign.users.include? user)
      end
      can [:create, :new], Grid

      #Token permissions
      can [:index, :up, :down], Token
      can :index, Token, :grid

      #Roll permissions
      can [:show], Roll
      can [:new, :create], Roll do |roll|
        if roll.nil? || roll.character.nil?
          #Yus. Yus you may go ahead.
          true
        else
          #We are actually creating a roll, so character /must/ be defined, and must match the current user.
          roll.character.user_id == user.id
        end
      end
    end
  end
end
