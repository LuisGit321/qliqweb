class TmpXcap < ActiveRecord::Base
  establish_connection "sip_server"
  set_table_name 'xcap'
end
