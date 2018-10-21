# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def welcome_email
    UserMailer.with(user: User.first).welcome_email
  end

  def verification_email
    UserMailer.with(user: User.first).verification_email
  end

  def anounce_election
    UserMailer.with(user: User.first, election: Election.first).anounce_election
  end

  def forget_password
    UserMailer.with(user: User.first).forget_password
  end

  def passphrase_reset
    UserMailer.with(user: User.first).passphrase_reset
  end

  def block_mined
    UserMailer.with(user: User.first).block_mined
  end
end
