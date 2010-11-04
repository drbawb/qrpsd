class Grid < ActiveRecord::Base
    has_many :tokens
    belongs_to :campaign
    
    def tablerefresh
      i = 0
      result = []
      tokens = self.tokens.order("turn_order ASC")
      tokens << tokens.shift # 0th token, counter-intuitively, belongs at end of stack
      
      tokens.each_with_index { |token, index|
         if token.tblrow.nil? == FALSE
            token_image = token.image_url
            #json_result = "{'id': '#{token.id}', 'image': #{token_image}, 'tblrow': '#{token.tblrow}', 'tblcol': '#{token.tblcol}', 'turn_order': '#{token.turn_order}', 'hp': '99'}"
            json_result = {:id => token.id, :image => token_image, :tblrow => token.tblrow, :tblcol => token.tblcol, :turn_order => index + 1, :hp => token.hp}
            #temp_result = "#{token.id}_#{token_image}_#{token.tblrow}_#{token.tblcol}_#{token.turn_order}_#{token.hp}"
            result << json_result
         end
      }
      return result.to_json
    end
    
    def unplaced
        result_array = []
        self.tokens.each {|token|
            temp_hash = {:id => '', :name => ''}
            if token.tblrow.nil? || token.tblcol.nil?
                temp_hash[:id] = token.id
                temp_hash[:name] = token.character.name if token.character.nil? != TRUE
                result_array.push(temp_hash) if token.character.nil? != TRUE
            end
            
        }
        return result_array
    end


    def placed
      tokens = self.tokens
      result_hash = {}
      tokens.each do |token|
        if !(token.tblrow.nil?) && !(token.tblcol.nil?)
          coord_string = "#{token.tblrow}_#{token.tblcol}"
          result_hash[coord_string] = token
        end
      end

      return result_hash
    end
end
