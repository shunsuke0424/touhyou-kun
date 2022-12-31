class ApplicationController < ActionController::Base
  before_action :set_current_user
  
  def set_current_user
    user = User.find_by(id: session[:user_id])
    @current_user = user || User.find_by(name: "ゲストユーザ")
  end
  
  def authenticate_user
    if @current_user == nil
      flash[:notice] = "ログインが必要です"
      redirect_to("/login")
    end
  end
  
  def forbid_login_user
    if @current_user && @current_user.name != "ゲストユーザ"
      flash[:notice] = "すでにログインしています"
      redirect_to("/")
    end
  end
end
