class User < ApplicationRecord
  has_many :voters
  has_many :candidates
end
