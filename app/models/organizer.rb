class Organizer < ApplicationRecord
  belongs_to :user
  belongs_to :election
  belongs_to :access_right

  def self.discard(id)
    org = Organizer.find(id)
    org.deleted_at = DateTime.now
    User.discard(org.user_id) if org.save
  end
end
