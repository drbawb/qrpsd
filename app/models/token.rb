class Token < ActiveRecord::Base
    belongs_to :grid
    belongs_to :character
    before_destroy :prepare_destroy
    #acts_as_list :scope => 'grid_id = #{grid_id} AND tblrow IS NOT NULL AND tblcol IS NOT NULL'

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

    def prepare_destroy
      Token.update_all("turn_order = (turn_order - 1)", "grid_id = #{self.grid_id} AND turn_order > #{self.turn_order}")
    end
end
