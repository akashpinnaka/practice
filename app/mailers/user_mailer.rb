class UserMailer < ActionMailer::Base

	def signup_confirmation(user)
		@user = user
		mail(to: user.email, from: "developer@notebook.com",subject: "Signup Confirmation")
	end

end