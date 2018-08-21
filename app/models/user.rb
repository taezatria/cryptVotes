class User < ApplicationRecord
	has_many :candidates
	has_many :voters

	def login(username, password)
		user = User.find_by(:username => username, :password => password)
		user.present?
	end
end
