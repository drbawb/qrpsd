class Token < ActiveRecord::Base
    belongs_to :grid
    belongs_to :character
    
    def find_above
      #Return the token above me
    end

    def find_below
      #Return the token below me
    end
    
    def swap_with(other_token)
      temp_turn_order = self.turn_order
      self.turn_order = other_token.turn_order
      other_token.turn_order = temp_turn_order
    end
end
