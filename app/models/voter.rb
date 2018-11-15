class Voter < ApplicationRecord
  belongs_to :user
  belongs_to :election

  def self.discard(voter_id)
    voter = Voter.find(voter_id)
    el = Election.find(voter.election_id)
    parti = el.participants
    el.participants = parti - 1
    el.save
    voter.destroy
    # User.discard(voter.user_id)
  end
end
