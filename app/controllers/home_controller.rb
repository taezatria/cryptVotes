class HomeController < ApplicationController
  def index
  end

  def login
    redirect_to '/organize'
    # if params[:username].present? && params[:password].present?
    #   user = User.login(params[:username], params[:password])
    #   if user.present?
    #     session[:current_user_id] = user
    #     redirect_to '/organize'
    #   else 
    #     flash[:error] = "Username or password doesn't match"
    #     redirect_back fallback_location: root_path
    #   end
    # end
  end
end
