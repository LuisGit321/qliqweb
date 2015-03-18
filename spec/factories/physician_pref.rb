Factory.define :physician_pref, :class => PhysicianPref do |pp|
  pp.number_of_days_to_bill 10
  pp.fax_to_primary 1
  pp.defacto_facility_id nil
end
