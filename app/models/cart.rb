class Cart < ActiveRecord::Base
  has_many :line_items
  has_one :order

  def total_price
    if line_items.size > 0
      line_items.collect { |l| l.quantity*l.price }.inject() { |result, element| result + element }
    else
      0
    end
  end

  def purchased
    line_items.each do |line_item|
      line_item.purchasable.purchased
    end
  end

  def verify!
    item = self.line_items.first
    if item && item.purchasable.nil?
      item.destroy
    end
  end
end
