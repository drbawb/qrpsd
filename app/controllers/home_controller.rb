class HomeController < ApplicationController
  before_filter :setsession
  
  private
    def setsession
      if current_user
        #@session = current_user
        session[:current_user] = current_user
      end
    end
  
  public
    def index
      @title = 'Weclome to qRPSdRail'
      begin
        #@grid = Grid.find(1)
      rescue ActiveRecord::RecordNotFound
        #@grid = nil
      end
    end
    
    def about
    end
    
    def test_grid
    end
end
