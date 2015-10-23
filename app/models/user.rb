class User < ActiveRecord::Base

	has_secure_password

	has_many :notes

	validates :username,:email, :uniqueness => true
	validates :password, :length => {:within => 6..35}
	validates :first_name, :last_name, :username, :email, :presence => true
	# validates :password_confirmation, {:message => "Password confirmation doesn't match"}



end
