class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]

  def index
    @items = Item.all.limit(3).order(id: "DESC")
  end

  def new
    @item = Item.new
    @item.images.new
    @parents = Category.where(ancestry: nil)
    @category_parent_array = ["---"]
    Category.where(ancestry: nil).each do |parent|
      @category_parent_array << parent.name
    end
  end

  def create
     @item = Item.new(item_params)
     if @item.save
      redirect_to root_path
     else
      render "new"
    end
  end

  def show
    @category = Category.find(@item.category_id)
    @order = Order.new
    @message = Message.new
    @messages = @item.messages.order(id: "ASC").includes(:user)
    @users = User.find(params[:id]) 
  end

  def edit
    @parents = Category.where(ancestry: nil)
  end

  def update
    # binding.pry
    @parents = Category.where(ancestry: nil)
   if  @item.image.blank?
      redirect_to item_path
   else 
      @item.update(item_update_params)
      redirect_to root_path
   end
  end

  def destroy
    @item.destroy
    redirect_to root_path
  end

  def set_item
    @item = Item.find(params[:id])
  end

  def get_category_children
    @category_children = Category.find_by(name: "#{params[:parent_name]}", ancestry: nil).children
  end

  def get_category_grandchildren
    @category_grandchildren = Category.find("#{params[:child_id]}").children
  end

  private
  def item_params
    params.require(:item).permit(:name,:price,:description,:brand,:category_id,:condition_id,:deriver_charge_id,:prefecture_id,:deriver_date_id,[images_attributes: [:image_url]]).merge(user_id:current_user.id).merge(category_id: params[:category_id])
  end

  def item_update_params
    params.require(:item).permit(:name,:price,:description,:brand,:category_id,:condition_id,:deriver_charge_id,:prefecture_id,:deriver_date_id,[images_attributes: [:image_url, :_destroy, :id]]).merge(user_id:current_user.id)
  end

end
