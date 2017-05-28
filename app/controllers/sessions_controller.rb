class SessionsController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.find_by(username: params[:username])
    if @user.authenticate(params[:password])
      sessions[:user_id] = @user_id
      redirect_to @user
    else
      render :new
    end
  end

  def destroy
    reset_session
    redirect_to login_path
  end

end