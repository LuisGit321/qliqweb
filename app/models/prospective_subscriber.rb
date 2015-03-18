class ProspectiveSubscriber < ActiveRecord::Base
  has_one :physician_group, :class_name => "ProspectivePhysicianGroup"
  has_one :billing_address, :class_name => "ProspectiveSubscriberBillingAddress"

  validates :email, :presence => true, :subscriber_email => {:message => 'Email has already been taken'}, :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }
  validates :password, :presence => true,
            :confirmation => true,
            :length => {:within => 6..40},
            :on => :create
  validates :password, :confirmation => true,
            :length => {:within => 6..40},
            :allow_blank => true,
            :on => :update

  accepts_nested_attributes_for :physician_group

  before_save :encrypt_password_as_devise

  private
  def encrypt_password_as_devise
    encryptor_class = Devise::Encryptors.const_get(Devise.encryptor.to_s.classify)
    self.password_salt = encryptor_class.salt(Devise.stretches)
    self.password = encryptor_class.digest(password, Devise.stretches, self.password_salt, Devise.pepper)
  end
end