class Admin::CoinsController < Admin::BaseController

  def create
    @user = User.find(params[:user_id])
    @user.coins << Coin.create(coin_params)
    redirect_to admin_user_path(@user)
  end

  def coin_params
    params.require(:coin).permit(:denom)
  end

end