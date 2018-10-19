class Candidate < ApplicationRecord
  belongs_to :user
  belongs_to :election

  def self.discard(candidate_id)
    candidate = Candidate.find(candidate_id)
    candidate.deleted_at = DateTime.now
    User.discard(candidate.user_id) if candidate.save
  end

end
