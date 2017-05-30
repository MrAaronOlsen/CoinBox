class ClaimRewardController < ApplicationController

  def show
    @user = User.find(params[:user_id])
    reward = Reward.find(params[:id])

    if @user.claim(reward)
      flash[:success] = 'Reward Claimed!'
      redirect_to @user
    else
      flash[:failure] = 'Something Went Wrong. Reward not Claimed...'
      redirect_to @reward
    end 
  end

end