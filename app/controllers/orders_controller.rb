class OrdersController < ApplicationController
  def new
  end

  def create
    @order = Order.new(params[:order].merge({:cart_id => current_cart.id}))
    @order.ip_address = request.remote_ip
    @failed = true
    respond_to do |format|
      if  current_cart.line_items.size > 0 && @order.save
        if @order.purchase
          current_cart.purchased
          @failed = false
          user = current_cart.line_items.first.purchasable.add_to_real_records
          sign_out
          session[:user_id] = user.id
          session[:prospective_subscriber_id] = nil

          format.html { redirect_to edit_physician_group_path(user.resource), :notice=> 'checkout successfull!'
          return
          }
          format.js {
            @user = current_user || User.find(session[:user_id])
            @physician_group = @user.resource
            (@physician_group.providers-@physician_group.physicians.size).times { @physician_group.physicians.build { |p| p.build_user } }
            1.times { @physician_group.billing_agencies.build { |p| p.build_user } }
          }
        end
      end
      if @failed
        current_cart.verify!
        @cart = current_cart
        @item = @cart.line_items.first
        if @item.nil?
          flash[:error] = 'No Item found'
          format.html { redirect_to new_subscribe_path }
          format.js
        else
          flash[:error] = 'checkout failed! '+@order.errors.full_messages.join(', ')
          format.html {
            redirect_to subscribe_path(current_cart.line_items.first.purchasable.name)
          }
          format.js
        end
      end
    end
  end

end
