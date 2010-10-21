# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
	def loginh
	  render :partial => 'layouts/loginh'
      	end
	
	def navh(links)
	   #Expects: [['Human Name','relative path'] ..]; relative path should be generated with _path methods
	   #We use arrays to preserve insertion orders; will use hashes in Ruby 1.9.1 when we get there
	   render :partial => 'layouts/navh', :locals => {:links => links}       
	end
end
