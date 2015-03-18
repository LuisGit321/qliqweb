Factory.define :agency_employee do |ae|
  ae.billing_agency_id "2"
  ae.name "billemp"
  ae.employee_number 123
  ae.phone "12121212121"
  ae.address "testaddress"
  ae.city "testcity"
  ae.state "AK"
  ae.zip "12345"
  ae.association :user, :factory => :billingfunctional
end

Factory.define :agency_employee_name_email, :class => AgencyEmployee do |ae|
  ae.billing_agency_id "2"
  ae.name "billemp"
  ae.association :user, :factory => :billingfunctional
end

Factory.define :agency_employee_name, :class => AgencyEmployee do |ae|
  ae.billing_agency_id "2"
  ae.name "billemp"
  ae.association :user, :factory => :billingfunctional
end

