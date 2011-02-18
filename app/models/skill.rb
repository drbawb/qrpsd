class Skill < ActiveRecord::Base
  has_many :player_skills, :dependent => :destroy
  has_many :characters, :through => :player_skills
  
  accepts_nested_attributes_for :player_skills
  attr_accessible :name, :description
	
	## scope :deselected, lambda { |*args| {:conditions => ["id NOT IN (SELECT skill_id FROM player_skills WHERE character_id = ?)", (args.first)]} }
	## above is bad because it uses a NOT IN(sub-select), outer join should be slightly more performant
	
	## Uses select("") to disambiguate column names returned by this scope.
	scope :deselected, select("skills.*").joins("LEFT OUTER JOIN player_skills ON skills.id=player_skills.skill_id").where("player_skills.character_id IS NULL")
end
