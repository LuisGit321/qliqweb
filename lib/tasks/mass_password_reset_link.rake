task :mass_password_reset_link, [:physician_group_id] => :environment do |t, args|
  physician_group_id = args.physician_group_id
  physician_group = PhysicianGroup.find(physician_group_id)
  unless physician_group.nil?
    physician_group.physicians.each do |physician|

      ph_user = physician.user
      #next if ph_user.created_at < ph_user.updated_at
      ph_user.reset_password_token= User.reset_password_token
      ph_user.save
      Notifier.physicians_password_reset_notification(ph_user).deliver
     #puts 'done for physician '+ ph_user.email
    end
    physician_group.billing_agencies.each do |staff|
      st_user = staff.user
      st_user.reset_password_token = User.reset_password_token
      st_user.save
      Notifier.staffs_password_reset_notification(st_user, physician_group).deliver
     #puts 'done for staff '+st_user.email
    end
    #if physician_group.physician_itself?
      physician_group.user.set_user_sip_config
      Subscriber.initial_setup_sip_subscriber(physician_group.user)
    #end

  end
end
