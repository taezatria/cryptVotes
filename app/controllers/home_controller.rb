class HomeController < ApplicationController
  def index
  end

  def login
    @params = params
    render :index
  end
end
