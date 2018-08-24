USER_LOGIN_KEY = "userloggedin".freeze

class User < ApplicationRecord
  has_many :voters
  has_many :candidates

  def self.login(username, password)
    user = User.find_by(username: username, password: password)
    $redis.set(USER_LOGIN_KEY+user.id.to_s, true) if user.present?
    user.present?
  end
end
