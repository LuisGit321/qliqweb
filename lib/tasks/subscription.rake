namespace :subscription do
  desc "Create new subscription"
  task :create, [:group_nos, :users_per_group, :use_demo_data, :clean_up_first] => [:environment] do |t, args|
    args.with_defaults(:group_nos => 4, :users_per_group => 25, :use_demo_data => true, :clean_up_first => true)

    Rake.application.invoke_task("subscription:clean_up:all_subscription_data") if args[:clean_up_first].to_s == 'true'

    require 'factory_girl'
    require File.dirname(__FILE__) + '/../../spec/factories/users'
    require File.dirname(__FILE__) + '/../../spec/factories/physician_groups'
    require File.dirname(__FILE__) + '/../../spec/factories/factories'
    require File.dirname(__FILE__) + '/../../spec/factories/physicians'
    require File.dirname(__FILE__) + '/../../spec/factories/physician_pref'
    if  args[:use_demo_data].to_s == 'true'
      data = Spreadsheet.open "#{RAILS_ROOT}/db/xls/Demo_Data.xls"

      sheet2 = data.worksheet 1
      i=0
      prepared_data = []
      physicians_data = []
      group_admin_user_name = nil
      sheet2.each do |row|
        i += 1
        next if i == 1

        if row[1].present?
          group_admin_user_name ||= row[0]
          physicians_data << {:first_name => row[1], :last_name => row[3], :email=> row[6], :specialty => row[5]}
        else
          prepared_data << {:name => group_admin_user_name, :physicians_data => physicians_data}
          group_admin_user_name = nil
          physicians_data = []
        end


      end
      j = 1
      prepared_data.each do |data|
        gau_email = data[:name].split(' ').collect { |c| c.chars.first }.join().downcase + '@qliqsoft.com'
        group_admin_user = Factory.build(:group_admin_user, :email => gau_email)
        group_admin_user.resource = Factory.build(:physician_group, :first_name => "group_user#{j}", :last_name => 'iphone')
        group_admin_user.resource.billing_info = Factory.build(:billing_info)
        data[:physicians_data].each do |physician_data|
          group_admin_user.resource.physicians << Factory.build(:physician, :first_name => physician_data[:first_name], :last_name => physician_data[:last_name], :specialty => physician_data[:specialty], :user => Factory.build(:physician_functional_user, :password => '123456', :email => physician_data[:email]))
        end
        group_admin_user.save!
        group_admin_user.set_user_sip_config
        Subscriber.initial_setup_sip_subscriber(group_admin_user)
        group_admin_user.resource.physicians.each_with_index do |physician, phi|
          physician.user.update_attribute(:password, '123456')
          physician.user.set_user_sip_config
          Subscriber.initial_setup_sip_subscriber(physician.user)
          puts "Done with Physician Group #{data[:name]} and Physician##{physician.first_name}"
        end

        puts "Finished with Physician group #{data[:name]} "
        j += 1
      end
      #raise prepared_data.inspect
    else
      args[:group_nos].to_i.times do |gni|
        group_admin_user = Factory.build(:group_admin_user, :email => "q#{gni+1}@qliqsoft.com")
        group_admin_user.resource = Factory.build(:physician_group, :first_name => "qliquser#{gni+1}", :last_name => 'iphone')
        group_admin_user.resource.billing_info = Factory.build(:billing_info)
        args[:users_per_group].to_i.times do |upgi|
          group_admin_user.resource.physicians << Factory.build(:physician, :first_name => "qliquser#{gni+1}#{upgi+1}", :last_name => 'iphone', :user => Factory.build(:physician_user, :password => '123456', :email => "q#{gni+1}#{upgi+1}@qliqsoft.com"))
        end
        group_admin_user.save!
        group_admin_user.set_user_sip_config
        Subscriber.initial_setup_sip_subscriber(group_admin_user)
        group_admin_user.resource.physicians.each_with_index do |physician, phi|
          physician.user.update_attribute(:password, '123456')
          physician.user.set_user_sip_config
          Subscriber.initial_setup_sip_subscriber(physician.user)
          puts "Done with Physician Group#{gni+1} and Physician##{phi+1}"
        end

        puts "Finished with Physician group ##{gni+1}"
      end
    end

  end

  namespace :clean_up do
    desc "Clean up users with dependencies"
    task :users => :environment do
      puts "deleting users with dependencies..."
      User.destroy_all
    end

    desc "Clean up subscribers"
    task :subscribers => :environment do
      puts "deleting subscriber..."
      Subscriber.destroy_all
    end

    desc "Clean up xcap table"
    task :xcap => :environment do
      puts "deleting from xcap table..."
      TmpXcap.destroy_all
    end
    desc "Clear users, subscriber and sip db"
    task :all_subscription_data => [:users, :subscribers, :xcap] do
      puts "All subscription data clean up done."
    end

  end
end