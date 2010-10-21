class PlayerSkill < ActiveRecord::Base
  attr_accessor :name #Virtual name magic
  
  belongs_to :character
  belongs_to :skill
  
  accepts_nested_attributes_for :skill
  accepts_nested_attributes_for :character

  validates_numericality_of :level
  validates_uniqueness_of :skill_id, :scope => [:character_id]
  validate :ensure_skill_exists

  
  def ensure_skill_exists
    errors.add_to_base "Skill not existent" unless Skill.find_by_id(self.skill_id)
  end
end
