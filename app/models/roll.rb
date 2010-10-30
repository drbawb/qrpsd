## Stores, represents, and manipulates a Roll. Which is the immutable state of several rolled dice, belonging to a single user.
class Roll < ActiveRecord::Base
  require 'drb'
  belongs_to :character
  serialize :resultarray
  
  attr_accessible :query, :character, :type
  attr_protected :dice #Dice objects will be stored in this instance variable; temporarily.
  
  validates_presence_of :character, :message => "is required"
  validates_presence_of :query, :message => "is required"
  validate :validate_dice_objects

  before_save :populate_resultarray

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
  def validate_dice_objects
    @dice = parse_query(self.query)
    if @dice.length < 1
      errors.add(:base, "Could not generate any dice from input query!")
      return false
    else
      return true
    end
  end

  def populate_resultarray
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
