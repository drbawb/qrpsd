class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :http_authenticatable, :token_authenticatable, :confirmable, :lockable, :timeoutable and :activatable
  devise :registerable, :database_authenticatable, :recoverable,
         :rememberable, :trackable, :validatable

	has_many :characters, :dependent => :destroy
	has_many :campaigns, :dependent => :destroy
	has_many :rolls, :through => :characters
	
  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :username,  :password, :password_confirmation

  def role?(input_role)
    if self.role == input_role
      return true
    end
  end
end
