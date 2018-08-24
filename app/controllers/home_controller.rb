class HomeController < ApplicationController
  def index
  end

  def login
    @params = params
    if params[:username].present? && params[:password].present?
      user = User.login(params[:username], params[:password])
      @params[:user] = user
      user ? (render :dashboard) : (redirect_back fallback_location: root_path)
    end
  end
end
