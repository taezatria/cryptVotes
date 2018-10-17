class User < ApplicationRecord
  USER_LOGIN_KEY = "userloggedin".freeze

  has_many :voters
  has_many :candidates
  has_many :organizers
  has_many :transactions

  def self.login(username, password)
    user = User.find_by(username: username, password: password)
    if user.present?
      $redis.set(USER_LOGIN_KEY+user.id.to_s, true)
      user.id
    end
  end

  def self.change_password(user_id, password)
    user = User.find(user_id)
    if user.present?
      user.password = password
      user.save
    end
  end
end
