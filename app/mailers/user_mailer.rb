class UserMailer < ApplicationMailer
  default from: 'admin-notification@cryptvotes.com'

  def welcome_email
    @user = params[:user]
    @url = "http://192.168.108.134:6789"
    mail(to: @user.email, subject: 'Welcome to CryptVotes')
  end

  def verification_email
    @user = params[:user]
    @url = "http://192.168.108.134:6789/home/"+@user.id.to_s+"/setup"
    mail(to: @user.email, subject: 'E-mail Verification')
  end

  def anounce_election
    @user = params[:user]
    @election = params[:election]
    mail(to: @user.email, subject: 'Election Date Reminder')
  end

  def forget_password
    @user = params[:user]
    @url = ''
    mail(to: @user.email, subject: 'Forget Password Verification')
  end

  def passphrase_reset
    @user = params[:user]
    @url = ''
    mail(to: @user.email, subject: 'Passphrase Reset Request')
  end

  def block_mined
    @user = params[:user]
    @blockhash = params[:blockhash]
    @txid = params[:txid]
    mail(to: @user.email, subject: 'Ballot Block Detail')
  end
end
