Factory.define :valid_prospective_physician_group, :class => ProspectivePhysicianGroup do |u|
  u.first_name 'Ravi'
  u.last_name 'Ada'
  u.address "15/2, foo bar"
  u.name "RA inc"
  u.providers 2
  u.state 'LA'
  u.city 'LA'
  u.zip '12345'
  u.phone '123-234-1234'
  u.fax '1234567890'
end

Factory.define :invalid_prospective_physician_group, :class => ProspectivePhysicianGroup do |u|

end
