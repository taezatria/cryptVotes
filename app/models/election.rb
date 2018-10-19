class Election < ApplicationRecord
  has_many :voters
  has_many :candidates
  has_many :organizers
  has_many :transactions

  def self.discard(election_id)
    el = Election.find(election_id)
    el.deleted_at = DateTime.now
    el.save
  end
end
