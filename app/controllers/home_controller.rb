class HomeController < ApplicationController
  def index
  end

  def login
    if params[:username].present? && params[:password].present?
      loggedin = User.login(params[:username], params[:password])
      loggedin ? render :index : redirect_to :back
    end
  end
end
