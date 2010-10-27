## Stores and represents a dice object: <any> number of <similarly faced> dice. (i.e: 5x20-sided dice.)
class Die
  attr_accessor(:num_sides, :num_dice, :str_type)

  ## Initializes a Die object to n-dice, with n-faces, of "damage-type."
  def initialize(dice, sides, type)
    begin
      if (dice.to_i.class == Fixnum) && (sides.to_i.class == Fixnum) && (type.class == String)
        @num_dice = dice.to_i
        @num_sides = sides.to_i
        @str_type = type
      else
        raise ArgumentError, "arguments were #{dice}, #{sides}, #{type} (dice,sides,type)"
      end
    end
  end

  ## Randomly populates a resultant array based on the Die object's initalized state.
  ## * Will return [TOTAL, TYPE, [DIE_1_RESULT, DIE_2_RESULT, ...]]
  def roll
    arr_results = [0, "", []]

    (1..@num_dice).each do
      num_temp_rand = rand(@num_sides) + 1
      arr_results[0] += num_temp_rand
      arr_results[2].push(num_temp_rand)
    end
    arr_results[1] = @str_type
    return arr_results
  end
end
