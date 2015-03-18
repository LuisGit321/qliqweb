  class ProspectivePhysicianGroup < ActiveRecord::Base
  belongs_to :prospective_subscriber
  validates :first_name, :last_name, :address, :name, :state, :city, :presence => true
  validates :providers, :presence => true, :numericality => {:only_integer => true}
  validates :zip, :presence => true, :format => {:with => /^\d{5}(-?\d{4})?$/, :message => 'Invalid zip code'}
  validates :phone, :presence => true, :format => {:with => /^(\d{3}-?){2}\d{4}$/, :message => 'Invalid phone number'}
  validates :fax, :format => {:with => /^(\d{3}-?){2}\d{4}$/, :allow_blank => true, :message => 'Invalid fax number'}

  def listing_charge
    #per provider
    50
  end

  def purchased
    self.update_attribute(:paid, true)
  end

  def prepare_order_object
    Order.new(
        :first_name => first_name,
        :last_name => last_name,
        :country => 'US',
        :state => state,
        :city => city,
        :zip_code => zip,
        :phone => phone,
        :email => admin_email
    )
  end

  def add_to_real_records
    user = User.new(:email => prospective_subscriber.email, :password => '1234567',
                    :password_confirmation => '1234567',
                    :resource_attributes => attributes.delete_if { |key, value| ['id', 'prospective_subscriber_id'].include?(key) })
    user.roles = ROLES[GROUP_ADMIN].to_a
    user.save!
    user.set_password_and_salt(prospective_subscriber.password, prospective_subscriber.password_salt)
    physician_group = user.resource
    physician_group.build_billing_info(prospective_subscriber.billing_address.attributes.delete_if { |key, value| ['id', 'prospective_subscriber_id'].include?(key) })
    physician_group.save!
    prospective_subscriber.update_attribute(:passed_step, 3)
    user
  end

  #acting methods to make identical to real data
  def billing_info
    prospective_subscriber.billing_address
  end

  def user
    prospective_subscriber
  end

  def billing_info
     prospective_subscriber.billing_address
  end
  #end acting methods
end
