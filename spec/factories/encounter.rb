Factory.define :encounter, :class => Encounter do |e|
  e.date_of_service DateTime.now.to_date
  e.encounter_cpts {|encounter_cpts| [encounter_cpts.association(:encounter_cpt)]}
end
