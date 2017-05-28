class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.profile = Profile.create

    if @user.save
      flash[:success] = "User Successfully Created. Please Login."
      redirect_to login_path
    else
      render :new
    end

  end

  def user_params
    params.require(:user).permit(:username, :password)
  end
end