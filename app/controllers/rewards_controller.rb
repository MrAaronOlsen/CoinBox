class RewardsController < ApplicationController

  def show
    @reward = Reward.find(params[:id])
  end

end