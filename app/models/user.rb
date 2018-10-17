class User < ApplicationRecord
  USER_LOGIN_KEY = "userloggedin".freeze

  has_many :voters
  has_many :candidates
  has_many :organizers
  has_many :transactions

  def self.login(username, password)
    user = User.find_by(username: username, password: password)
    
    if user.present?
      organizer = Organizer.find_by(user_id: user.id)
      voter = Voter.find_by(user_id: user.id)
      if organizer.present?
        if organizer.access_right_id == AccessRight.first.id
          status = -1
        else
          status = 1
        end
      elsif voter.present?
        status = 0
      end

      $redis.set(USER_LOGIN_KEY+user.id.to_s, status)
      { user_id: user.id, status: status }
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
