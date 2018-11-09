class Candidate < ApplicationRecord
  belongs_to :user
  belongs_to :election

  def self.discard(candidate_id)
    Candidate.find(candidate_id).destroy
    # User.discard(candidate.user_id)
  end

end
