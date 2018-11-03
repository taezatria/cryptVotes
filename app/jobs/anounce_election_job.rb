class AnounceElectionJob < ApplicationJob
  queue_as :default

  def perform(users, election)
    users.each do |user|
      UserMailer.with(user: user, election: election).anounce_election.deliver_later
    end
  end
end
