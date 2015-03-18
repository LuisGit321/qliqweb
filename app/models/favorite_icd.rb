class FavoriteIcd < ActiveRecord::Base
  set_table_name 'favorite_icd'
  belongs_to :physician, :class_name => 'Physician', :foreign_key => :physician_id
  belongs_to :icd, :class_name => 'Icd', :foreign_key => :icd_id
end
