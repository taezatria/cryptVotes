class Election < ApplicationRecord
  has_many :voters
  has_many :candidates
  has_many :organizers
  has_many :transactions
end
