class HomeController < ApplicationController
  def index
  end

  def login
    if params[:username].present? && params[:password].present?
      @loggedin = User.login(params[:username], params[:password])
      flash[:notice] = 'Loggedin' if @loggedin
      @loggedin ? (render :index) : (redirect_back fallback_location: root_path)
    end
  end
end
