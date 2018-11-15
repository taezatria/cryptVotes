class Voter < ApplicationRecord
  belongs_to :user
  belongs_to :election

  def self.discard(voter_id)
    Voter.find(voter_id).destroy
    # User.discard(voter.user_id)
  end
end
