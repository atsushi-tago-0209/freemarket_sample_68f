class OrdersController < ApplicationController
  def  done
    @product_purchaser= Order.find(params[:id])
    @product_purchaser.update( order_id: current_user.id)
   end

end
