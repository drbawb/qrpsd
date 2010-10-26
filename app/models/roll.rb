## Stores, represents, and manipulates a Roll. Which is the immutable state of several rolled dice, belonging to a single user.
class Roll < ActiveRecord::Base
  require 'drb'
  belongs_to :character
  serialize :resultarray
  
  attr_accessible :query, :character, :type
  attr_protected :dice #Dice objects will be stored in this instance variable; temporarily.
  
  validates_presence_of :character, :message => "is required"
  validates_presence_of :query, :message => "is required"
  
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

  ## Parses query using specific regular expression
  # * The capturing groups are as follows:
  # * An example query of maximum complexity is: [1d4] is fire + [2d20] + 4 is water + 8
  # * match[0] = Number of die.
  # * match[1] = Number of faces per die.
  # * match[2] = "Bonus modifier" (does not create dice object, always rolls maximum value.)
  ## * match[3] = Damage type (anything following the pattern " is ".)
  def parse_query(query)
    pattern = /(?:\[(\d*)d(\d*)\]|(\d+))(?: is (.+?))?(?= \+ |$)/
    matches = query.scan(pattern)
    arr_results = []
    matches.each do |match|
      if match[2].nil? == false # If capturing group 3 (bonus modifier) is not empty, process as a bonus
        match[3].nil? ? arr_results << [match[2], "standard", [match[2]]] : arr_results << [match[2],match[3], [match[2]]] # If 4th capturing group [the type] is nil, set type to standard
      elsif match[1].nil? == false # If capturing group 2 (dice) is not empty, process it instead
        match[3].nil? ? arr_results << Die.new(match[0], match[1], "standard") : arr_results << Die.new(match[0], match[1], match[3]) # If 4th capturing group is nil, set type to standard
      end
    end
    return arr_results
  end

  ## This creates a "resultarray" to be serialized to the database.
  #
  # This is the format that the RollsController#show view is expecting to parse.
  #
  ## The dice are created but <b>not rolled</b> until this action is finished.
  def validate
	@dice = parse_query(self.query)
	if @dice.length < 1
	  errors.add_to_base("Could not generate any dice from input query!")
	  return false
	else
      return true
    end
  end
  
  def before_save
    #[[3, "standard", [3]], [7, "fire", [7]], ["4", "standard", ["4"]], ["8", "fire", ["8"]]]
    #query: "[1d4] + [1d8] is fire + 4 + 8 is fire"
    self.resultarray = []
	@dice.each do |x|
      if x.class == Die
        self.resultarray << x.roll
      else
        self.resultarray << x
      end
    end
  end
end
