module OrganizeHelper

  def all_elections
    Election.where(deleted_at: nil)
  end

  def all_voters
    User.joins(:voters).where(deleted_at: nil).distinct
  end

  def all_candidates
    User.joins(:candidates).where(deleted_at: nil).distinct
  end

  def all_organizers
    User.joins(:organizers).where(deleted_at: nil).distinct
  end

  def all_access_rights
    AccessRight.where(deleted_at: nil)
  end

  def all_users
    User.where(deleted_at: nil)
  end

  def voter(id, election = 1)
    if election == 1
      Voter.where(user_id: id, deleted_at: nil)
    else
      Voter.where(user_id: id, election_id: election, deleted_at: nil)
    end
  end

  def candidate(id, election = 1)
    if election == 1
      Candidate.where(user_id: id, deleted_at: nil)
    else
      Candidate.where(user_id: id, election_id: election, deleted_at: nil)
    end
  end

  def organizer(id, election = 1)
    if election == 1
      Organizer.where(user_id: id, deleted_at: nil)
    else
      Organizer.where(user_id: id, election_id: election, deleted_at: nil)
    end
  end
end
