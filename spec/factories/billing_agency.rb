Factory.define :valid_agency, :class => BillingAgency  do |ba|
  ba.name "Test_Physician_group"
  ba.address "Street 5, Bunglow 503"
  ba.state "AA"
  ba.city "London"
  ba.zip "41231"
  ba.phone "123-123-1234"
  ba.fax "123-123-1234"
  ba.association :user, :factory => :billingadmin
end

Factory.define :billing_agency_user, :class => User  do |ba|
  ba.association :user, :factory => :billingadmin
end

Factory.define :valid_name_phone_email_agency, :class => BillingAgency  do |ba|
  ba.name "Agency_name"
  ba.phone "123-123-1234"
  ba.association :user, :factory => :billingadmin
end

Factory.define :phone_nil_agency, :class => BillingAgency  do |ba|
  ba.name "test123"
  ba.phone 
end

Factory.define :email_nil_agency, :class => BillingAgency  do |ba|
  ba.name "test123"
  ba.phone "123-123-1234"
end

Factory.define :name_nil_agency, :class => BillingAgency  do |ba|
  ba.name 
  ba.phone "123-123-1234"
end

Factory.define :name_space_blank_agency, :class => BillingAgency  do |ba|
  ba.name " "
  ba.phone "123-123-1234"
end

Factory.define :group_billing_agency, :class => BillingAgency  do |ba|
  ba.name "Agency 1"
  ba.user { |ba| ba.association(:billing_admin_user) }
  ba.phone "123-123-1234"
end

Factory.define :group_billing_agency2, :class => BillingAgency  do |ba|
  ba.name "Agency 2"
  ba.phone "123-123-1234"
end

Factory.define :billing_agency, :class => BillingAgency  do |ba|
  ba.sequence(:name){ |n| "Agency#{n}"}
  ba.phone "123-123-1234"
  ba.zip "123456"
end

