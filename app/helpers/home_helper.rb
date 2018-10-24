module HomeHelper

  def all_elections
    Election.where(status: 3, deleted_at: nil).where('? > end_date', DateTime.now)
  end
end