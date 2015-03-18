class FacilityType < ActiveRecord::Base
  set_table_name 'facility_type'
  has_one :physician_superbill
  has_many :facilities
end
