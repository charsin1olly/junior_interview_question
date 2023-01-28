require './models/campaign.rb'
require './models/order.rb'

# 計算規則
#
# 1. 消費未滿 $1,500, 則須增加 $60 運費
# 2. 若消費期間有超過兩個優惠活動，取最優者折扣 
# 3. 運費計算在優惠折抵之後
#
# Please implemenet the following methods.
# Additional helper methods are recommended.

class PriceCalculation
  def initialize(order_id)
    @order = Order.find(order_id)
    raise Order::NotFound if @order.nil?
  end

  def total
    total_after_discount

    if free_shipment?
      @total
    else
      @total = @total+60
    end
  end

  def total_after_discount
    discount_ratio = Campaign.running_campaigns(@order.order_date).map{|order| (order.discount_ratio)}.max
    
    if discount_ratio.present?
      @total = @order.price*(100-discount_ratio)/100
    else
      @total = @order.price
    end
  end

  def free_shipment?
    total_after_discount >1500
  end
end
