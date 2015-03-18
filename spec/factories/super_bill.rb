Factory.define :super_bill, :class => Superbill do |sb|
  sb.sequence(:name) {|n| "HospitalistTemplate#{n}"}
  sb.state_id nil
  sb.specialty_id 1
  sb.association :billing_agency
  sb.superbill_cpts {|scpts| [scpts.association(:superbill_cpts)]}
end

Factory.define :super_bill_name_speciality_agency_emp, :class => Superbill do |sb|
  sb.name "test_superbill123"
  sb.specialty_id 1
  sb.association :billing_agency
  sb.superbill_cpts {|scpts| [scpts.association(:superbill_cpts)]}
end

Factory.define :super_bill_name_speciality, :class => Superbill do |sb|
  sb.name "testing_superbill"
  sb.specialty_id 1
  sb.association :billing_agency
  sb.superbill_cpts {|scpts| [scpts.association(:superbill_cpts)]}
end

Factory.define :super_bill_name_speciality_state, :class => Superbill do |sb|
  sb.name "test_superbill_state"
  sb.specialty_id 1
  sb.state_id 1
  sb.association :billing_agency
  sb.superbill_cpts {|scpts| [scpts.association(:superbill_cpts)]}
end
