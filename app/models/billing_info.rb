class BillingInfo < ActiveRecord::Base
  belongs_to :resource, :polymorphic => true

  validates :first_name, :last_name, :company, :email, :address1, :state, :city, :presence => true
  validates :zip, :presence => true, :format => {:with => /^\d{5}(-?\d{4})?$/, :message => 'Invalid zip code'}
  validates :phone, :presence => true, :format => {:with => /^(\d{3}-?){2}\d{4}$/, :message => 'Invalid phone number'}

  def credit_card_hash
    {:value => Marshal.dump({
                                :card_type => card_type,
                                :card_number => card_number,
                                :card_expires_on_month => card_expires_on_month,
                                :card_expires_on_year => card_expires_on_year,
                                :card_verification => card_verification
                            }), :expires => 1.hour.from_now}
  end
end
