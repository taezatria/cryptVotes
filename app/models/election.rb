class Election < ApplicationRecord
    has_many :candidates
    has_many :voters
end
