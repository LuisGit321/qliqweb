Factory.define :referring_physician, :class => ReferringPhysician do |rp|
  rp.sequence(:name) {|n| "referphy#{n}"}
  rp.fax "1-408-999 8888"
end
