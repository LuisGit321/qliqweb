class AppYetTobeRegistered < ActiveRecord::Base
  set_table_name 'app_yet_tobe_registered'
  belongs_to :physician, :class_name => 'Physician', :foreign_key => :physician_id
end
