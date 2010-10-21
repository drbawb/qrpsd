class Sheet < ActiveRecord::Base
	belongs_to :character
	validates_presence_of :character
	validates_associated :character
	#http://soggymilk.com/system/sheets/1/original/sheet.png?1285880119
	
	has_attached_file :sheet,
  	:path => ":rails_root/public/system/:attachment/:id/:style/:basename.:extension",
	:url => ":rel_path/system/:attachment/:id/:style/:basename.:extension" #subdirectory hack 
 	
	validates_attachment_presence :sheet
	validates_attachment_content_type :sheet, :content_type => ['application/pdf', 'image/jpeg', 'image/png', 'image/gif']
  private
  def validate
    if (defined? character.user_id) && (@user_ses.id != character.user_id)
      errors.add(:character, "not yours #{@user_ses.id} plus #{character.user_id}")
    end
  end
end
