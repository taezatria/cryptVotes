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

  def voter(id)
    Voter.where(user_id: id, deleted_at: nil)
  end

  def candidate(id)
    Candidate.where(user_id: id, deleted_at: nil)
  end

  def organizer(id)
    Organizer.where(user_id: id, deleted_at: nil)
  end
end
