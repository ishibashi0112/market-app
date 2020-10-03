class ItemsController < ApplicationController
  require 'payjp'
  before_action :authenticate_user! , only: [:new]
  before_action :set_api_key, only:[:buy_check_page, :pay]
  before_action :set_card_table_id, only:[:buy_check_page, :pay]
  before_action :set_item, only:[:destroy,:edit,:update]
  before_action :set_image_category, only:[:edit, :update]
  before_action :set_category_parent_array, only: [:new, :create, :edit, :update]
  
  def index
    @items = Item.includes(:images).order("created_at DESC")
  end

  def new
    @item = Item.new
    @item.images.build
  end

  def create
    @item = Item.new(item_params)
    @item.seller_id = current_user.id
    if @item.save
      redirect_to root_path
    else
      render :new
    end
  end

  def destroy
    if @item.destroy
      redirect_to index_more_new_page_items_path, notice: "商品を削除しました。" 
    else
      render :index_more_new_page, notice: "商品を削除できませんでした。" 
    end
  end


  def show
    @item = Item.find(params[:id])
    @parents = Category.where(ancestry:nil)
    # impressionist(@item)
    # , nil, :unique => [:session_hash]
    # @page_views = @item.impressionist_count
  end

  
  def edit

  end

  def update
    if item_params[:images_attributes].nil?
      flash.now[:alert] = '更新できませんでした。出品画像をアップロードしてください。'
      render :edit
    else
      if @item.update(item_params)
        redirect_to  update_done_items_path
      else
        flash.now[:alert] = '更新できませんでした'
        render action: :edit
      end
    end
  end

  def update_done
    @item_update = Item.order("updated_at DESC").first
  end
  
  def index_more_new_page
    @items = Item.includes(:images).order("created_at DESC").page(params[:page]).per(12)
  end

#   購入機能--------------------------------------------------------------------
  def buy_check_page
    @item = Item.find(params[:id])
    if @card.present?
      @customer = Payjp::Customer.retrieve(@card.customer_id) 
      @default_card = @customer.cards.retrieve(@customer.default_card)
    else
      
    end
  end

  def pay
    @item = Item.find(params[:id])
    @customer = Payjp::Customer.retrieve(@card.customer_id)

    Payjp::Charge.create(
      amount: @item.price,
      customer: @customer, 
      currency: 'jpy'
    )
    
    @item.update( buy_status: 1 ,buyer_id: current_user.id )
    redirect_to done_page_items_path
  end

  def done_page
  end
# --------------------------------------------------------------------------------
  


#   カテゴリー機能--------------------------------------------------------------------
  def get_category_children
    @category_children = Category.find("#{params[:parent_id]}").children
  end

  def get_category_grandchildren
    @category_grandchildren = Category.find("#{params[:child_id]}").children
  end
# -----------------------------------------------------------------------------------

  private
  def item_params
    params.require(:item).permit(:name,:description,:brand_name,:item_condition,:shipping_payer,:shipping_from_area,:shipping_duration,:price,:buy_status,:image_id,:category_id,images_attributes:[:id,:image,:item_id,:_destroy])
    # .merge(seller_id: current_user.id)
  end
  
  def set_item
    @item = Item.find(params[:id])
  end

  def set_api_key
    Payjp.api_key = ENV['SECRET_KEY']
  end

  def set_card_table_id
    @card = Card.find_by(user_id: current_user.id)
  end

  def set_category_parent_array
    @category_parent_array = []
    Category.where(ancestry: nil).each do |parent|
      @category_parent_name_id = [parent.name, parent.id]
      @category_parent_array << @category_parent_name_id
    end
  end

  def set_image_category
    @parents = Category.where(ancestry:nil)
    @parent_id = Category.find(@item.category_id).parent.parent.id
    @child_id = Category.find(@item.category_id).parent.id
    @grandchild_id = Category.find(@item.category_id).id
    children = Category.find(@item.category_id).parent.siblings
    grandchildren = Category.find(@item.category_id).siblings
    @category_child_array = []
    @category_grandchild_array = []
    children.each do |child|
      @category_child_name_id = [child.name, child.id]
      @category_child_array << @category_child_name_id
    end
    grandchildren.each do |grandchild|
      @category_grandchild_name_id = [grandchild.name, grandchild.id]
      @category_grandchild_array << @category_grandchild_name_id
    end
    @image = Image.where(item_id:params[:id])
    @image_size = @image.size
  end

end
# if @item.save
#   params[:images]['image'].each do |a|
#     @item_image = @item.images.create!(image: a)
#   end
#   redirect_to root_path, notice: '出品しました。'
# else
#   render :new
# end