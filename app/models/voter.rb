class Voter < ApplicationRecord
  belongs_to :user
  belongs_to :election

  def self.attend(voter_id)
    voter = Voter.find(voter_id)
    voter.hasAttend = true
    voter.save
    #generate blockchain address
  end
end
