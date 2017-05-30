class Admin::DashboardController < Admin::BaseController

  def show
    @user = User.find(params[:id])
    @users = User.all
    @rewards = Reward.all
  end

end