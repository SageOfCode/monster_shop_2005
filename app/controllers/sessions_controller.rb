class SessionsController < ApplicationController

  def new
    if session[:user_id] != nil
      flash[:notice] = "You are already logged in!"
      redirect_user
    end
  end

  def create
    user = User.find_by(email: params[:email])
    if user != nil && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_user
    else
      flash[:error] = "Either email or password were incorrect"
      redirect_to "/login"
    end
  end

  def destroy
    reset_session
    flash[:notice] = "You have logged out"
    redirect_to root_path
  end

  private
  def redirect_user
    if current_user.role == "default"
      redirect_to "/profile"
    elsif current_employee?
      redirect_to '/merchant'
    else current_admin?
      redirect_to '/admin'
    end
  end
end
