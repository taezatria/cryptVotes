class Voter < ApplicationRecord
  belongs_to :user
  belongs_to :election

  def self.discard(voter_id)
    voter = Voter.find(voter_id)
    voter.deleted_at = DateTime.now
    User.discard(voter.user_id) if voter.save
  end
  
  def self.attend(user_id)
    Voter.where(user_id: user_id, hasAttend: false, hasVote: false, deleted_at: nil).each do |voter|
      voter.hasAttend = true
      voter.save
    end
  end
end
