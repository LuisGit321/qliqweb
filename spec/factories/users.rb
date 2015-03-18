Factory.define :systemadmin, :class => User  do |u|
  u.email "usersuper@something.com"
  u.password "usersuper" 
  #u.roles ROLES[SYSTEM_ADMIN].to_a
end

Factory.define :groupadmin, :class => User  do |u|
  u.email "usergroup@something.com"
  u.password "usersuper" 
  #u.roles ROLES[GROUP_ADMIN].to_a
end

Factory.define :physicianadmin, :class => User  do |u|
  u.email "userphysician@something.com"
  u.password "usersuper" 
  #u.roles ROLES[PHYSICIAN_ADMIN].to_a
end

Factory.define :physicianfunctional, :class => User  do |u|
  u.email "userphysician@something.com"
  u.password "usersuper" 
  #u.roles ROLES[PHYSICIAN_FUNCTIONAL].to_a
end

Factory.define :billingadmin, :class => User  do |u|
  u.email "userbilling@something.com"
  u.password "usersuper" 
  #u.roles ROLES[BILLING_ADMIN].to_a
#  u.association :resource, :factory => :valid_agency
 # u.association :billing_agency, :factory => :valid_agency
end

Factory.define :billingfunctional, :class => User  do |u|
  u.email "useremployee@something.com"
  u.password "usersuper" 
  #u.roles  ROLES[BILLING_FUNCTIONAL].to_a
end

Factory.define :super_user, :class => User  do |u|
  u.email "u@11something.com" 
  u.password "usersuper" 
  u.roles ROLES[SYSTEM_ADMIN].to_a
  u.resource_type "Super Admin"
end

Factory.define :group_admin_user, :class => User  do |u|
  u.sequence(:email){|n| "group_admin_user#{n}@qliqsoft.com"}
  u.password "123456"
  u.roles  ROLES[GROUP_ADMIN].to_a
end

Factory.define :physician_admin_user, :class => User  do |u|
  u.sequence(:email){|n| "physician_admin_user#{n}@qliqsoft.com"}
  u.password "usersuper" 
  u.roles  ROLES[PHYSICIAN_ADMIN].to_a
end

Factory.define :physician_functional_user, :class => User  do |u|
  u.sequence(:email){|n| "physicianfunctional#{n}@gmail.com"} 
  u.password "usersuper" 
  u.roles  ROLES[PHYSICIAN_FUNCTIONAL].to_a
end

Factory.define :billing_admin_user, :class => User  do |u|
  u.email "u12@something.com" 
  u.password "usersuper" 
  #u.roles  ROLES[BILLING_ADMIN].to_a
end

FactoryGirl.define do
  factory :user do
    email                  { Factory.next :email }
    password               "s3cr3tp4ss"
    password_confirmation  "s3cr3tp4ss"
    #username               { Factory.next :username }

    factory :physician_user do
      resource_type "Physician"
    end

    factory :physician_group_user do
      resource_type "PhysicianGroup"
    end
  end
end
