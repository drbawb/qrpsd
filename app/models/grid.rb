class Grid < ActiveRecord::Base
    has_many :tokens
    belongs_to :campaign
    
    def tablerefresh
      i = 0
      result = []
      self.tokens.each { |token|
         if token.tblrow.nil? == FALSE
            token_image = token.image_url
            #json_result = "{'id': '#{token.id}', 'image': #{token_image}, 'tblrow': '#{token.tblrow}', 'tblcol': '#{token.tblcol}', 'turn_order': '#{token.turn_order}', 'hp': '99'}"
            json_result = {:id => token.id, :image => token_image, :tblrow => token.tblrow, :tblcol => token.tblcol, :turn_order => token.turn_order, :hp => token.hp}
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
        #Dimension a 27x27 sided array (later - the grid size.)
        result_array = Array.new(27)
        result_array.collect! {|array|
            array = Array.new(27) # each array element becomes an array of its own
        }
        result_array[0][0] = '-'
        i = 1
        for x in 'A'..'Z'
            result_array[0][i] = x
            i+=1
        end
        for y in '1'..'26'
            result_array[(y.to_i)][0] = y
        end
        
        temp_hash = {}
        self.tokens.each {|token|
            if token.tblrow.nil? != TRUE && token.tblcol.nil? != TRUE
                temp_hash[:id] = token.id
                temp_hash[:name] = token.character.name
                #result_array[token.tblrow.to_i][token.tblcol.to_i] = temp_hash   
            	result_array[token.tblrow.to_i][token.tblcol.to_i] = token    
            end
        }
        return result_array
    end
end
