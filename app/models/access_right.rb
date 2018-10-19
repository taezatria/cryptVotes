class AccessRight < ApplicationRecord
  has_many :organizers

  def self.discard(id)
    ar = AccessRight.find(id)
    ar.deleted_at = DateTime.now
    ar.save
  end
end
