Factory.define :physician, :class => Physician do |phy|
phy.first_name "fn"
phy.last_name "ln"
phy.specialty "Hospitalist"
phy.npi "sd" 
phy.mobile "1234567890"
phy.phone "123-123-1234"
phy.fax "123-123-1234"
phy.sequence(:email) {|n| "physician#{n}@qliqsoft.com"}
phy.subscribe_to_iphone 1
phy.subscribe_to_web 1
phy.salutation "Dr."
phy.no_of_billing_days 2
phy.user { |p| p.association(:physician_functional_user) }
phy.physician_pref { |p| p.association(:physician_pref) }
end

Factory.define :physician_group_admin, :class => Physician  do |p|
  p.sequence(:name){|n| "physician_group_admin#{n}"}
  p.user { |p| p.association(:group_admin_user) }
  p.physician_superbills {|physician_superbills| [physician_superbills.association(:physician_superbills)]}
  p.association :physician_group
end

Factory.define :physician_admin, :class => Physician  do |p|
  p.name "Physician 1"
  p.user { |p| p.association(:physician_admin_user) }
  #p.physician_group { |p| p.association(:with_billing_agency_physician_group) } 
end

Factory.define :physician_functional, :class => Physician  do |phy|
  phy.sequence(:name) {|n| "Physician#{n}"}
  phy.user { |p| p.association(:physician_functional_user) }
  phy.patients {|patients| [patients.association(:patient)]}
  phy.physician_superbills {|physician_superbills| [physician_superbills.association(:physician_superbills)]}
  phy.physician_pref {|p| p.association(:physician_pref)}
  phy.specialty "Hospitalist"
  phy.npi "npi"
  phy.mobile "0987654321"
  phy.fax "123-123-1234"
  phy.sequence(:email){|n| "physician_functional#{n}@gmail.com"}
  phy.username nil
  phy.password nil
  phy.subscribe_to_iphone  1
  phy.subscribe_to_web 1
  phy.salutation "Dr."
  phy.no_of_billing_days nil 
  phy.print_id nil
  phy.after_create {|bp| Factory.create(:billing_pref, :resource_id => bp.id, :resource_type => "Physician") }
end
