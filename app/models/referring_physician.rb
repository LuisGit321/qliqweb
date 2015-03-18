class ReferringPhysician < ActiveRecord::Base
  set_table_name 'referring_physician'
  has_many :hospital_episodes, :class_name => 'HospitalEpisode'
  has_many :patients, :through => :hospital_episodes, :source => :patient
  belongs_to :resource, :polymorphic => true

  validates :name, :presence => true
  validates :fax, :presence => true, :format => { :with =>  /^(\d{3}-){2}\d{4}$/, :message =>  'Invalid fax number'}

  validates_format_of :phone, :with =>  /^(\d{3}-){2}\d{4}$/, :allow_blank => true, :message => 'Invalid phone number'

  validates_format_of :email, :with =>  /^[\w\d]+@[\w\d]+(\.[\w\d]+)+$/, :allow_blank => true, :message => 'Invalid email'
  validates_numericality_of :zip, :greater_than_or_equal_to => 0 , :less_than_or_equal_to => 999999,  :allow_blank => true, :only_integer => true, :message => 'Invalid value for zip'
  validate :validate_zip
  def validate_zip
    unless self.zip.empty?
      validates_length_of :zip, :minimum => 5, :maximum => 10, :message=>"Zip code should consist 6 digits"
    end
  end

  scope :private, :conditions => { :visible_to_group => false }
  scope :visible, :conditions => { :visible_to_group => true }
end
