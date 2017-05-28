class SessionsController < ApplicationController

  def new
  end

  def create
    @user = User.find_by(username: params[:session][:username])

    if @user && @user.authenticate(params[:session][:password])
      flash[:msg] = "Logged in as #{@user.username}"
      session[:user_id] = @user.id
      redirect_to @user
    else
      flash[:msg] = 'Login Failed'
      redirect_to users_path
    end
  end

  def destroy
    session.clear
    flash[:msg] = 'Logged Out'
    redirect_to users_path
  end

end