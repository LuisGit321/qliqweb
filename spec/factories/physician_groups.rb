FactoryGirl.define do
  factory :physician_group do  |pg|
    pg.name            "Amazing Group"
    pg.address         "742 Evergreen Terrace"
    pg.address2        "123 Fake St."
    pg.providers       2
    pg.paid            true
    pg.city            "Springfield"
    pg.state           "State"#{ Factory( :state ).name }
    pg.zip             "12345"
    pg.phone           "555-742-3232"
    pg.fax             "555-354-6720"
    pg.sequence(:admin_email) {|n| "admin_email#{n}@qliqsoft.com"}
    #admin_email     { Factory.next :email }
    pg.admin_password  "s3cr3tp4ss"
  end
end

Factory.define :with_billing_agency_physician_group, :class => PhysicianGroup  do |pg|
  pg.billing_pref { |pg| pg.association(:physician_group_pref) } 
end
