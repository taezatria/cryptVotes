module VoterHelper

  def all_elections_vote(user)
    el = []
    Voter.where(user_id: user, hasAttend: true, hasVote: false).each do |voter|
      el.push(voter.election_id)
    end
    Election.where(id: el, status: 1, deleted_at: nil).where('? BETWEEN start_date AND end_date', DateTime.now)
    # Election.all
  end

  def all_elections_end(user)
    el = []
    Voter.where(user_id: user, hasAttend: true, hasVote: true).each do |voter|
      el.push(voter.election_id)
    end
    Election.where(id: el, deleted_at: nil).where('? > start_date', DateTime.now)
    # Election.all
  end
end
