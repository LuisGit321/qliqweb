class CustomProcedure < ActiveRecord::Base
  set_table_name 'custom_procedure'
  belongs_to :physician, :class_name => 'Physician', :foreign_key => :physician_id
end
