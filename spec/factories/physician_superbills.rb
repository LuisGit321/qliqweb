Factory.define :physician_superbills, :class => PhysicianSuperbill do |ps|
  ps.association :superbill, :factory => :super_bill
  ps.preferred 1 
end
