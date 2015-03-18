class Order < ActiveRecord::Base
  belongs_to :cart
  has_many :transactions, :class_name => "OrderTransaction"

  attr_accessor :card_type, :card_number, :card_verification, :card_expires_on_month, :card_expires_on_year

  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :city, :presence => true
  validates :state, :presence => true
  #validates :country, :presence => true
  validates :zip_code, :presence => true
  validates :phone, :presence => true
  #validates :email, :presence => true, :format => {:with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :on => :create}
  validates :card_type, :card_verification, :card_expires_on_month, :card_expires_on_year, :presence => true
  validates  :card_verification, :presence => true, :numericality => {:only_integer => true}, :length => {:minimum => 3, :maximum => 4}
  validate :validate_card, :on => :create

  validates  :card_number, :presence => true,  :numericality => {:only_integer => true}, :credit_card_number => {:message => 'Invalid card cumber'}

#  with_options :if => lambda { |o| o.card_type == "visa" } do |on_condition|
#    on_condition.validates :card_number, :presence => true, :format => {:with => /^\d{16}$/, :message => 'Card number should have 16 digits'}
#  end
#  with_options :if => lambda { |o| o.card_type == "american_express" } do |on_condition|
#    on_condition.validates :card_number, :presence => true, :format => {:with => /^3[47][0-9]{13}$/, :message => 'American Express card number should have 15 digits'}
#  end

  def card_expires_on=(expire_date)
    "#{card_expires_on_year}-#{card_expires_on_month}"
  end

  def purchase
    response = GATEWAY.purchase(price_in_cents, credit_card, purchase_options)
    transactions.create!(:action => "purchase", :amount => price_in_cents, :response => response)
    cart.update_attribute(:purchased_at, Time.now) if response.success?
    errors.add_to_base response.message unless response.success?
    response.success?
  end

  def price_in_cents
    (cart.total_price*100).round
  end

  private

  def purchase_options
    {
        :ip => ip_address,
        :billing_address => {
            :name => "#{first_name} #{last_name}",
            :address1 => "#{address}",
            :city => "#{city}",
            :state => "#{state}",
            :country => "#{  }",
            :zip => "#{zip_code}"
        }
    }
  end

  def validate_card
    unless credit_card.valid?
      credit_card.errors.full_messages.each do |message|
        errors.add :base, message
      end
    end
  end

  def credit_card
    @credit_card ||= ActiveMerchant::Billing::CreditCard.new(
        #      #:type               => card_type,
    #      :number             => card_number,
    #      :verification_value => card_verification,
    #      :month              => card_expires_on.month,
    #      :year               => card_expires_on.year,
    #      :first_name         => first_name,
    #      :last_name          => last_name

    :type => card_type,
    :first_name => first_name,
    :last_name => last_name,
    :number => card_number,
    # :number             => '4242424242424242',
    :month => card_expires_on_month,
    :year => card_expires_on_year,
    :verification_value => card_verification
    #:verification_value => '123'

    )
  end
end
