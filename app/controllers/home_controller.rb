class HomeController < ApplicationController
  def index
  end

  def setup_account
    redirect_to '/home'
  end
  
  def setup
    render 'setup'
  end

  def email
  end

  def verify
    render 'verify'
  end

  def login
    # redirect_to '/organize'
    if params[:username].present? && params[:password].present?
      user = User.login(params[:username], params[:password])
      if user.present?
        session[:current_user_id] = user[:user_id]
        if user[:status] == 0
          redirect_to '/voter'
        else
          redirect_to '/organize'
        end 
      else 
        flash[:error] = "Username or password doesn't match"
        redirect_back fallback_location: root_path
      end
    end
  end

  def result
    if params[:id].present?
      @dummy = {
        "Abang Randi" => 10,
        "Bung Hassa" => 5,
        "Om Toddi" => 15,
        "Abstance" => 3
      }
      render 'viewresult'
    else
      render 'result'
    end
  end
end
