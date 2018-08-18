class Candidate < ApplicationRecord
    belongs_to :elections, :users
end
