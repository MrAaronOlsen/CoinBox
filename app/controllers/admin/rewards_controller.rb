class Admin::RewardsController < Admin::BaseController

  def new
    @reward = Reward.new
  end

  def create
    @reward = Reward.new(reward_params)

    if @reward.save
      flash[:success] = "Reward Created"
      redirect_to admin_dashboard_path(current_user)
    else
      render :new
    end
  end

  def reward_params
    params.require(:reward).permit(:name, :desc, :cost)
  end
end