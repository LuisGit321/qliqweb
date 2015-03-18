Factory.sequence :state_code do |code|
  code
end

Factory.sequence :state_name do |number|
  "State #{ number }"
end

Factory.sequence :email do |n|
  "homer#{ n }@thesimpsons.com"
end

Factory.sequence :username do |n|
  "bart#{ n }"
end
