class Voter < ApplicationRecord
    belongs_to :voters, :elections
end
