class Character < ActiveRecord::Base
  belongs_to :user
  belongs_to :campaign
  has_many :sheets, :dependent => :destroy
  has_many :tokens, :dependent => :destroy
  has_many :rolls, :dependent => :destroy

  has_many :player_skills, :dependent => :destroy, :include => :skill
  has_many :skills, :through => :player_skills
  accepts_nested_attributes_for :player_skills, :allow_destroy => true
  
  validates_presence_of :user_id
  validates_presence_of :campaign, :message => " must be specified and open."
  validates_associated :campaign
  

  def pre_save(params)
    delete_arr = []
    params[:player_skills_attributes].each do |ps|
      if ps[:level] == "" && ps[:id] != ""
        delete_arr << ps[:id]
      end
    end
    PlayerSkill.delete(delete_arr)
  end
end
