class User < ActiveRecord::Base

	has_secure_password

	has_many :notes

	validates :username,:email, uniqueness:true



end
