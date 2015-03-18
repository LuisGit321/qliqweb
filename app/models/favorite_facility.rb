class FavoriteFacility < ActiveRecord::Base
  set_table_name 'favorite_facility'
  belongs_to :physician, :class_name => 'Physician', :foreign_key => :physician_id
  belongs_to :facility, :class_name => 'Facility', :foreign_key => :facility_id
end
