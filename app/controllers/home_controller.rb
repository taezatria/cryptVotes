class HomeController < ApplicationController
  def index
  end

  def login
    if params[:username].present? && params[:password].present?
      user = User.login(params[:username], params[:password])
      user ? (redirect_to '/organize') : (redirect_back fallback_location: root_path)
    end
  end
end
