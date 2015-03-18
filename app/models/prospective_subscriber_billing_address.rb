class ProspectiveSubscriberBillingAddress < ActiveRecord::Base
  belongs_to :prospective_subscriber
  validates :first_name, :last_name, :company, :email, :address1, :state, :city, :presence => true
  validates :zip, :presence => true, :format => {:with => /^\d{5}(-?\d{4})?$/, :message => 'Invalid zip code'}
  validates :phone, :presence => true, :format => {:with => /^(\d{3}-?){2}\d{4}$/, :message => 'Invalid phone number'}

end
