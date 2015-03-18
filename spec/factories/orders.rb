Factory.define :valid_credit_card, :class => Order do |u|
  u.first_name 'Ravi'
  u.last_name 'Ada'
  u.state 'LA'
  u.city 'LA'
  u.zip_code '12345'
  u.phone '1231231234'
  u.card_type 'visa'
  u.card_number '4242424242424242'
  u.card_verification '123'
  u.card_expires_on_month 1.year.from_now.month
  u.card_expires_on_year 1.year.from_now.year
end

Factory.define :invalid_credit_card, :class => Order do |u|

end
