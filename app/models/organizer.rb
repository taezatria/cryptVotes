class Organizer < ApplicationRecord
  belongs_to :user
  belongs_to :election

  def self.discard(id)
    Organizer.find(id).destroy
    # User.discard(org.user_id)
  end
end
