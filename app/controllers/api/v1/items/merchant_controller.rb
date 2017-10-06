class Api::V1::Items::MerchantController < ApplicationController
  def index
    item = Item.find(item_params[:item_id].to_i)
    merchant = Merchant.find(item.merchant_id)
    render json: merchant
  end

  private

  def item_params
    params.permit(:item_id)
  end
end
