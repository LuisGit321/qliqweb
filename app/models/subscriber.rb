class Subscriber < ActiveRecord::Base
  establish_connection "sip_server"
  set_table_name 'subscriber'

  class << self
    def sip_db_update_subscriber(user)
      subscriber = Subscriber.find_by_email_address(user.email)
      subscriber = Subscriber.new(:email_address =>user.email) if subscriber.nil?
      subscriber.domain = SIP_DOMAIN
      subscriber.password = user.encrypted_password
      subscriber.username = user.custom_username
      #subscriber.email_address  = user.email
      ha1 = "#{subscriber.email_address}:#{SIP_DOMAIN}:#{subscriber.password}"
      ha1b = "#{subscriber.email_address}@:#{SIP_DOMAIN}:#{SIP_DOMAIN}:#{subscriber.password}"
      subscriber.ha1 = Digest::MD5.hexdigest(ha1)
      subscriber.ha1b = Digest::MD5.hexdigest(ha1b)
      subscriber.save!
      subscriber
    end



    def sip_db_delete_subscriber(user)
      # delete the user from SIP server
    end


    def update_presence_rules(user, subscriber)
      buddies = user.get_buddies_sip_uri
      sip_config = SIPConfig.new
      sip_config.update_presence_rules(user, buddies)
    end

    def remove_presence_rules(user, subscriber)
      # need to fill in
    end

    def initial_setup_sip_subscriber(user)
      # Add into Subscriber table and update presence rules
      subscriber = sip_db_update_subscriber(user)
      update_presence_rules(user, subscriber)
    end

    def delete_sip_subscriber(user)
      # delete the from Subscriber table and remove presence rules
      sip_db_delete_subscriber(user)
      remove_presence_rules(user, subscriber)
    end
  end


end
