class User < ApplicationRecord
    has_many :candidates, :voters
end
