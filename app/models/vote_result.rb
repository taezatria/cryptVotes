require 'csv'

class VoteResult < ApplicationRecord

  def self.to_csv
    attributes = column_names
    i = attributes.index "data"
    j = attributes.index "election"
    k = attributes.index "candidate"
    attributes[i] = "data_vote"
    attributes[j] = "election_name"
    attributes[k] = "candidate_name"

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |result|
        csv << attributes.map { |attr| result.send(attr) }
      end
    end
  end
  
  def data_vote
    raw = data.scan(/../).map { |x| x.hex.chr }.join.split('0x0')
    raw.join('-')
  end

  def election_name
    Election.find(election).name
  end

  def candidate_name
    unless candidate == 0
      User.find(candidate).name
    else
      "Abstance"
  end
end
