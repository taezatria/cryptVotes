class User < ApplicationRecord
  USER_LOGIN_KEY = "userloggedin".freeze

  has_many :voters
  has_many :candidates

  def self.login(username, password)
    user = User.find_by(username: username, password: password)
    if user.present?
      $redis.set(USER_LOGIN_KEY+user.id.to_s, true)
      user.id
    end
  end
end
