class ProfilesController < ApplicationController

  before_action :require_user

  def require_user
    render file: '/public/404' unless current_user?
  end

  def show
    @profile = Profile.find(params[:id])
  end

  def edit
    @profile = Profile.find(params[:id])
  end

  def update
    @profile = Profile.find(params[:id])

    if @profile.update(profile_params)
      flash[:succuss] = 'Profile Successfully Updated'
      redirect_to user_path(@profile.user)
    else
      render :edit
    end
  end

  def profile_params
    params.require(:profile).permit(:first_name, :last_name)
  end

end