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
end
