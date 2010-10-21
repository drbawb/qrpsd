class Skill < ActiveRecord::Base
  has_many :player_skills, :dependent => :destroy
  has_many :characters, :through => :player_skills
  
  accepts_nested_attributes_for :player_skills
  attr_accessible :name, :description
end
