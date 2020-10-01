class UsersController < ApplicationController
  before_action :set_user, only: [:show]
  def show
    @items = current_user.items
    @selling_id = Item.where(seller_id:current_user.id)
    @buying_id = Item.where(buyer_id:current_user.id)
  end


  def index_seller_page
    @items = current_user.items
    @selling_id = Item.where(seller_id:current_user.id)
    @items = Item.includes(:images).order("created_at DESC").page(params[:page]).per(12)
  end

  def index_buyer_page
    @items = current_user.items
    @buying_id = Item.where(buyer_id:current_user.id)
    @items = Item.includes(:images).order("created_at DESC").page(params[:page]).per(12)
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
  def user_params
    params.fetch(:user, {}).permit(:nickname).merge(seller_id: current_user.id, trading_status: 0)
  end
end
