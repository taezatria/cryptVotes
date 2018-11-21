class UserMailer < ApplicationMailer
  URL_HOME = "http://192.168.108.134:6789".freeze

  def welcome_email
    @user = params[:user]
    @url = URL_HOME
    mail(to: @user.email, subject: 'Welcome to CryptVotes')
  end

  def verification_email
    @user = params[:user]
    str = Digest::MD5.hexdigest(@user.id.to_s+@user.name+"setup")
    @url = URL_HOME+"/home/"+@user.id.to_s+"/setup/"+str
    mail(to: @user.email, subject: 'E-mail Verification')
  end

  def anounce_election
    @user = params[:user]
    @election = params[:election]
    mail(to: @user.email, subject: 'Election Date Reminder')
  end

  def forget_password
    @user = params[:user]
    str = Digest::MD5.hexdigest(@user.id.to_s+@user.name+"password")
    @url = URL_HOME+"/home/"+@user.id.to_s+"/forget/"+str
    mail(to: @user.email, subject: 'Forget Password Verification')
  end

  def passphrase_reset
    @user = params[:user]
    str = Digest::MD5.hexdigest(@user.id.to_s+@user.name+"passphrase")
    @url = URL_HOME+"/home/"+@user.id.to_s+"/genkey/"+str
    mail(to: @user.email, subject: 'Passphrase Reset Request')
  end

  def vote_success
    @user = params[:user]
    @election = params[:election]
    @txid = params[:txid]
    @url = URL_HOME+"/home/verify"
    mail(to: @user.email, subject: 'You have Voted !')
  end

  def block_mined
    @user = params[:user]
    @blockhash = params[:blockhash]
    @txid = params[:txid]
    @url = URL_HOME+"/home/verify"
    mail(to: @user.email, subject: 'Ballot Block Detail')
  end
end