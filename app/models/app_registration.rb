class AppRegistration < ActiveRecord::Base
  set_table_name 'app_registration'
  belongs_to :physician, :class_name => 'Physician', :foreign_key => :physician_id
end
