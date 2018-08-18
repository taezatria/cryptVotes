class Election < ApplicationRecord
    has_many :candidates, :voters
end
