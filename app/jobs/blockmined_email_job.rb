class BlockminedEmailJob < ApplicationJob
  queue_as :default

  def perform(user, blockhash, txid)
    UserMailer.with(user: user, blockhash: blockhash, txid: txid).block_mined.deliver_later
  end
end
