class Organizer < ApplicationRecord
  belongs_to :user
  belongs_to :election
  belongs_to :access_right
end
