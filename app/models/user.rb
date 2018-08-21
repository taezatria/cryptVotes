LOGGED_IN_USER_KEY = "loggedInUser".freeze

class User < ApplicationRecord
	has_many :candidates
	has_many :voters

	def self.login(username, password)
		user = User.find_by(:username => username, :password => password)
		$redis.set(LOGGED_IN_USER_KEY+user.id.to_s, Time.now) if user.present?
		user.present?
	end
end
