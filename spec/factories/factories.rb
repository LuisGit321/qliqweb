Factory.define :billing_info, :class => BillingInfo  do |pg|
  pg.sequence(:first_name){ |n| "first_name#{n}" }
  pg.sequence(:last_name){ |n| "last_name_#{n}" }
  pg.sequence(:email){|n| "billing_address#{n}@qliqsoft.com"}
  pg.address1 "address"
  pg.sequence(:company){ |n| "Company#{n}" }
  pg.state "AA"
  pg.city "London"
  pg.zip "41231"
  pg.phone  "123-123-1234"
end
