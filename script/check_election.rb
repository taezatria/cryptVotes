Election.where(deleted_at: nil).each do |election|
	if election.status == 0
		if DateTime.now == election.start_date
			election.status = 1
			election.save
		end
	elsif election.status == 1
		if DateTime.now == election.end_date
			election.status = 2
			election.save
		end
	elsif election.status == 2
		if DateTime.now + 6.days == election.end_date + 6.days
			election.status = 3
			election.save
		end
	end
end