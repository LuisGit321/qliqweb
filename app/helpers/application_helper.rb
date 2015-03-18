module ApplicationHelper

  def welcome_tag
    msg = ""

    if current_user.role?(ROLES[GROUP_ADMIN]) || current_user.role?(ROLES[PHYSICIAN_ADMIN])|| current_user.role?(ROLES[PHYSICIAN_FUNCTIONAL])
      name = "Welcome #{current_user.resource.first_name}" 
    elsif current_user.role?(ROLES[BILLING_ADMIN]) || current_user.role?(ROLES[BILLING_FUNCTIONAL])
      name = "Welcome #{current_user.resource.first_name}"
    else
      name = "Welcome Admin"
    end
    return name
  end

  def get_billing_agency_id
    if current_user.role?(ROLES[GROUP_ADMIN]) and current_user.resource.physician_group.billing_pref
      current_user.resource.billing_pref.billing_agency_id
    end
  end

  def get_cpts_codes(cpt_ids)
    cpts = Cpt.find(cpt_ids)
    cpts.collect(&:code).join(', ')
  end

  def get_summary_dates
    summary_dates = []
    for i in 0..6 
      summary_dates << (Date.today - i).strftime("%Y-%m-%d")
    end
    summary_dates
  end

  def get_patient_encounters_for_date(summary_dates, patient_id)
    encounters = Encounter.where("patient_id = ? and date_of_service in (?)", patient_id, summary_dates)
    encounters_dates = encounters.collect{|a| a.date_of_service.strftime("%Y-%m-%d")}
    [encounters, encounters_dates]
  end

  def get_latest_cpt(encounters, date)
    encounters.select{|a| a.date_of_service.strftime("%Y-%m-%d") == date}.first.cpts.first.cpt.code
  end

  def is_cpts_exists?(encounters, date)
    !encounters.select{|a| a.date_of_service.strftime("%Y-%m-%d") == date}.first.encounter_cpts.empty?
  end

  def get_patient_name(patient)
    name = "#{patient.first_name} #{patient.middle_name} #{patient.last_name} "
  end

  def menu_link_to(*args, &block)
    controller = args.shift
    action = args.shift

    if controller == controller_name && (action.nil? || action.include?(action_name) || action == "Any")
      if args.third.nil?
        args.push({:class => 'active'})
      else
        args.third.merge!({:class => 'active'})
      end
    end

    link_to *args, &block
  end

  def get_physician_details(physician_group)
    #physician_group =  physician_group.class.name == "PhysicianGroup" ? physician_group : physician_group.physician_group
    group = physician_group
    detail = ""
    detail += "<li>#{group.address} <br /></li>" unless group.address.blank?
    detail += "<li>#{group.city.to_s}, " unless group.city.blank?
    detail += "#{group.state}, " unless group.state.blank?
    detail += "#{group.zip}" unless group.zip.blank?
    detail += "</li>"
    detail += "<li>Phone :#{group.phone}</li>" 
  end

  def get_class_for_image(resource)
     resource.print.nil? ? "insert_photo" : "uploaded_photo"
  end

  def get_primary_icds(patient)
    a = EncounterIcd.where("primary_diagnosis = 1 and patient_id = #{patient.id}").select("code").joins(:icd, :encounter)
    a.empty? ? "-" : a.collect{|c| c.code}.join(', ')
  end

  def get_cpt_codes(patient)
    a = Encounter.where("patient_id = #{patient.id}").joins(:cpts => [:cpt]).select(:code)
    a.empty? ? "-" : a.collect{|c| c.code}.join(', ')
  end

  def patient_encounters(processed_date)
    encounters = Encounter.by_processed_date(processed_date)
    patients = encounters.collect(&:patient_id).uniq
    [encounters, patients]
  end

  def get_patient(patient_id)
    Patient.find(patient_id)
  end

  def encounter_icds(encounters, patient_id)
    ens = encounters.select{|e| e.patient_id == patient_id}
    icds = EncounterIcd.where("encounter_id in (?)", ens).joins(:icd).select(:code)
    icds.collect{|a| a.code}.uniq.join(', ')
  end

  def encounter_cpts(encounters, patient_id)
    ens = encounters.select{|e| e.patient_id == patient_id}
    cpts = EncounterCpt.joins(:superbill_cpt => [:cpt]).where("encounter_id in (?)", ens).select("code")
    cpts.collect{|a| a.code}.uniq.join(', ')
  end

  def link_to_remove_fields(name, f)
    f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)")
  end

  def link_to_add_fields(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    new_object.build_user
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render("physician_groups/#{association.to_s.singularize}", :f => builder)
    end
    link_to_function(name, raw("add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\"); validateNameAndEmail(); handleRemoveElement();"), :class => "btn")
  end
end
