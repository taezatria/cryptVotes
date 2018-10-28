require 'csv'

class VoteResult < ApplicationRecord

  def self.to_csv
    attributes = column_names
    i = attributes.index "data"
    attributes[i] = "data_vote"

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |result|
        csv << attributes.map { |attr| result.send(attr) }
      end
    end
  end
  
  def data_vote
    raw = data.scan(/../).map { |x| x.hex.chr }.join.split('00')
    raw.join('-')
  end
end
