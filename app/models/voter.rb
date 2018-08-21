class Voter < ApplicationRecord
    belongs_to :voters
    belongs_to :elections
end
