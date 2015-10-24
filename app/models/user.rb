class User < ActiveRecord::Base

	has_secure_password

	has_many :notes

	 has_attached_file :profile_picture, styles: {},
	                   :default_url => ":style/missing_avatar.png"
	 validates_attachment_content_type :profile_picture, :content_type => /\Aimage\/.*\Z/

	validates :username,:email, :uniqueness => true
	validates :password, :length => {:within => 6..35}
	validates :first_name, :last_name, :username, :email, :presence => true
	# validates :password_confirmation, {:message => "Password confirmation doesn't match"}



end
