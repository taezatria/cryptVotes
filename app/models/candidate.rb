class Candidate < ApplicationRecord
    belongs_to :elections
    belongs_to :users
end
