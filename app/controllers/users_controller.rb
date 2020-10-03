class UsersController < ApplicationController
  before_action :set_user, only: [:show]
  before_action :set_items, only: [:show,:index_seller_page,:index_buyer_page]
  before_action :set_seller_items, only: [:show,:index_seller_page]
  before_action :set_buyer_items, only: [:show,:index_buyer_page]
  before_action :set_pagenate, only: [:index_seller_page,:index_buyer_page]
  

  def show
  end


  def index_seller_page   
  end

  def index_buyer_page
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
  
  def set_items
    @items = current_user.items
  end

  def set_seller_items
    @selling_items = Item.where(seller_id:current_user.id)
  end

  def set_buyer_items
    @buying_items = Item.where(buyer_id:current_user.id)
  end

  def set_pagenate
    @items = Item.includes(:images).order("created_at DESC").page(params[:page]).per(12)
  end

  def user_params
    params.fetch(:user, {}).permit(:nickname).merge(seller_id: current_user.id, trading_status: 0)
  end
end
