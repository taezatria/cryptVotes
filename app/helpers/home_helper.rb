module HomeHelper

  def all_elections_result
    Election.where(status: 3, deleted_at: nil).where('? > end_date', DateTime.now)
  end

  def all_result_data(el)
    VoteResult.where(election: el, deleted_at: nil)
  end
end