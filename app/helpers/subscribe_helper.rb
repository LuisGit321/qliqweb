module SubscribeHelper
  def step1
    if @physician_group
  "<div class='create p_btm'><h3>Step 1:</h3><h3> #{link_to 'Create your qliqAccount', edit_subscribe_path(@physician_group), :remote => true} </h3> <strong> #{link_to "EDIT", edit_subscribe_path(@physician_group), :remote => true }</strong> </div>"
    else
  "<div class='create'><h3>Step 1:</h3><h3> Create your qliqAccount</h3> </div>"
    end
  end

  def step2
    if @physician_group and @physician_group.billing_info
  "<div class='create p_btm'><h3>Step 2:</h3><h3> #{link_to 'Billing Information', subscribe_edit_billing_information_path(@physician_group), :remote => true}</h3><strong> #{link_to "EDIT", subscribe_edit_billing_information_path(@physician_group), :remote => true } </strong></div>"
    else
  "<div class='create p_btm'><h3>Step 2:</h3><h3> Billing Information</h3> </div>"
      
    end
  end

  def step3
    if @physician_group and @physician_group.billing_info
  "<div class='create p_btm'><h3>Step 3:</h3><h3>#{link_to ' Review & Check Out',subscribe_path(@physician_group), :remote => true}</h3> <strong> #{link_to "SHOW", subscribe_path(@physician_group), :remote => true } </strong></div>"
    else
       "<div class='create p_btm'><h3>Step 3:</h3><h3> Review & Check Out</h3></div>"
    end
    end

  def step4
    if @physician_group
  "<div class='create p_btm'><h3>Step 4:</h3><h3> #{link_to 'Add Providers & Staff', edit_physician_group_path(@physician_group), :remote => true}</h3></div>"
    else
      "<div class='create p_btm'><h3>Step 4:</h3><h3>Add Providers & Staff</h3></div>"
    end
    end
end

