class LineItem < ActiveRecord::Base
  belongs_to :purchasable, :polymorphic => true
  belongs_to :cart
  validates :purchasable_id, :purchasable_type, :presence => true
  validates :quantity, :price, :numericality => true, :presence => true

  def full_price
    price * quantity
  end

  class << self
    def clear_and_create!(cart, user)
      existing_cart = self.find_by_cart_id(cart.id)
      attrs = {}
      if user.respond_to?(:resource) && !user.resource.paid?
        attrs = {:purchasable_id => user.resource.id, :purchasable_type=>'PhysicianGroup', :quantity => user.resource.providers, :price => user.resource.listing_charge}
      elsif user.respond_to?(:physician_group)&& !user.physician_group.paid?

        attrs = {:purchasable_id => user.physician_group.id, :purchasable_type=>'ProspectivePhysicianGroup', :quantity => user.physician_group.providers, :price => user.physician_group.listing_charge}
      end
      if existing_cart
        existing_cart.update_attributes(attrs)
      else
        create(attrs.merge(:cart_id => cart.id))
      end
    end
  end
end
