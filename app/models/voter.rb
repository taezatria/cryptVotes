class Voter < ApplicationRecord
  belongs_to :user
  belongs_to :election

  def self.discard(voter_id)
    Voter.find(voter_id).destroy
    # User.discard(voter.user_id)
  end
  
  def self.attend(user_id)
    Voter.where(user_id: user_id, hasAttend: false, hasVote: false, deleted_at: nil).each do |voter|
      voter.hasAttend = true
      voter.save
    end
  end
end
