class Facility < ActiveRecord::Base
  set_table_name 'facility'
  has_many :favorite_facilities, :class_name => 'FavoriteFacility'
  has_many :patients, :class_name => 'Patient'
  has_many :physician_prefs, :class_name => 'PhysicianPref'
  belongs_to :resource, :polymorphic => true
  belongs_to :facility_type

  validates :name, :presence => true
  validates :zip, :format => {:with => /^\d{5}(-?\d{4})?$/, :allow_blank => true, :message => 'Invalid zip code'}
  validates :phone, :presence => true, :format => {:with => /^(\d{3}-?){2}\d{4}$/, :message => 'Invalid phone number'}

  scope :private, :conditions => {:visible_to_group => false}
  scope :visible, :conditions => {:visible_to_group => true}
end
