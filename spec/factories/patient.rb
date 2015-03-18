Factory.define :patient, :class => Patient do |p|
  p.first_name 'Stone'
  p.middle_name 'cold'
  p.last_name 'steve austin'
  p.date_of_birth Date.today - 5.years 
  p.phone '123-123-1234'
  p.email 'austin@gmail.com'
  p.insurance 'Medicare'
  p.hospital_episodes {|he| [he.association(:hospital_episode)]} 
end
