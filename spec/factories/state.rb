FactoryGirl.define do
  factory :state do
    code { Factory.next :state_code }
    name { Factory.next :state_name }
  end
end
