module HomeHelper

  def all_elections_result
    Election.where(status: 3, deleted_at: nil).where('? > end_date', DateTime.now)
  end
end