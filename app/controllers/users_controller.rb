class UsersController < ApplicationController

  def new
    @user = User.new
    @profile = Profile.create
  end

  def create
    @user = User.new(user_params)

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