module VoterHelper

  def all_elections
    Election.where(deleted_at: nil)
  end
end
