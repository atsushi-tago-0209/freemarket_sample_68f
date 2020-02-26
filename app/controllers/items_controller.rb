class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]

  def index
    @items = Item.all.limit(3).order(id: "DESC")
  end

  def new
    @item = Item.new
    @item.images.new
  end

  def create
     @item = Item.new(item_params)
     @item.save
     redirect_to root_path
  end

  def show
    @message = Message.new
    @messages = @item.messages.order(id: "ASC").includes(:user)
  end

  def edit
  end

  def update
    @item.update(item_update_params)
    redirect_to root_path
    # root_pathの部分を、あとでマイページにとぶように再設定
    resource.image.attach(item_update_params[:image])
    resource_updated = update_resource(resource, item_update_params)

  end

  def destroy
    @item.destroy
    redirect_to root_path
  end

  def set_item
    @item = Item.find(params[:id])
  end

  private
  def item_params
    params.require(:item).permit(:name,:price,:description,:image,:brand,:category,:condition,:deriver_charge,:area,:deriver_date,[images_attributes: [:image_url]]).merge(user_id:current_user.id)
  end

  def item_update_params
    params.require(:item).permit(:name,:price,:description,:brand,:category,:condition,:deriver_charge,:area,:deriver_date,[images_attributes: [:image, :_destroy, :id]]).merge(user_id:current_user.id)
  end
end
