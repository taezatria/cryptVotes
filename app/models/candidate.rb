class Candidate < ApplicationRecord
  belongs_to :users
  belongs_to :elections
end
