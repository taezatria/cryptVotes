class Transaction < ApplicationRecord
	belongs_to :user
	belongs_to :election
end
