class VoteEmailJob < ApplicationJob
  queue_as :default

  def perform(user, txid, el)
    UserMailer.with(user: user, txid: txid, election: el).vote_success.deliver_later
  end
end
