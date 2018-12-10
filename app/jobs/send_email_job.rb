class SendEmailJob < ApplicationJob
  queue_as :default

  def perform(menu, user)
    if menu == "verify"
      UserMailer.with(user: user).verification_email.deliver_now!
    elsif menu == "welcome"
      UserMailer.with(user: user).welcome_email.deliver_now!
    elsif menu == "password"
      UserMailer.with(user: user).forget_password.deliver_now!
    elsif menu == "passphrase"
      UserMailer.with(user: user).passphrase_reset.deliver_now!
    end
  end
end
