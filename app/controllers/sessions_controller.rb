class SessionsController < ApplicationController

  def new
  end

  def create
    @user = User.find_by(username: params[:username])
    if @user && @user.authenticate(params[:password])
      flash[:msg] = "Logged in as #{@user.username}"
      session[:user_id] = @user.id
      if @user.profile.new?
        redirect_to edit_user_profile_path(@user, @user.profile)
      else
        redirect_to @user
      end
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