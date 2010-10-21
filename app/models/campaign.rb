class Campaign < ActiveRecord::Base
   belongs_to :user #This user is the DM
   has_many :characters, :dependent => :destroy #These are the user's characters
   has_many :users, :through => :characters #These are the playing USERS
   has_many :rolls, :through => :characters #These are the user's rolls
   has_many :grids, :dependent => :destroy #These are the campaign's battle mats
   
   
   protected
      def validate
         errors.add("user_id", "cannot be changed!") if (self.changed.include? "user_id") && (self.changes['user_id'][0].nil?) != TRUE
      end
end
