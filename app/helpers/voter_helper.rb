module VoterHelper

  def all_elections_vote(user)
    el = []
    Voter.where(user_id: user).each do |voter|
      el.push(voter.election_id)
    end
    Election.where(id: el, status: 1, deleted_at: nil).where('? BETWEEN start_date AND end_date', DateTime.now)
  end

  def all_elections_end(user)
    el = []
    Voter.where(user_id: user).each do |voter|
      el.push(voter.election_id)
    end
    Election.where(id: el, status: 2, deleted_at: nil).where('? > end_date', DateTime.now)
  end
end
