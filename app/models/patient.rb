class Patient < ActiveRecord::Base
  set_table_name 'patient'
  has_many :encounters, :class_name => 'Encounter', :dependent => :destroy
  has_many :hospital_episodes, :class_name => 'HospitalEpisode', :dependent => :destroy
  belongs_to :physician, :class_name => 'Physician', :foreign_key => :physician_id
  belongs_to :facility, :class_name => 'Facility', :foreign_key => :facility_id
  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :date_of_birth,:presence => true
  
  validate :validation_dob
  validates_format_of :phone, :with =>  /^(\d{3}-){2}\d{4}$/, :allow_blank => true, :message => 'Invalid phone number'

  validates_format_of :email, :with =>  /^[\w\d]+@[\w\d]+(\.[\w\d]+)+$/, :allow_blank => true, :message => 'Invalid email'
  
  accepts_nested_attributes_for :hospital_episodes, :allow_destroy => true 
  accepts_nested_attributes_for :encounters, :allow_destroy => true 

  scope :discharged, :conditions => ["note.type_id in (?)", [HOSPITAL_COURSE, MEDICATION, FOLLOWUP_INSTRUCTION]], :joins => [:encounters => [:notes]]

  scope :by_date, lambda{ |start_date, end_date| where("admit_date >= ? and admit_date <= ?", start_date, end_date).joins(:hospital_episodes, :encounters => [:notes])}
  
  if Rails.env == "development" || Rails.env == "test"
    scope :monthly_patients, lambda{|physicians, start_date, end_date| where("patient.physician_id in (?) and (date_of_service >= ? and date_of_service <= ?)", physicians, start_date, end_date).joins(:hospital_episodes, :encounters).group("strftime('%m', date_of_service)").select("count(distinct(patient.id)) as counts, strftime('%m', date_of_service) as month")}
  else
    scope :monthly_patients, lambda{|physicians, start_date, end_date| where("patient.physician_id in (?) and (date_of_service >= ? and date_of_service <= ?)", physicians, start_date, end_date).joins(:hospital_episodes, :encounters).group("date_part('month', date_of_service)").select("count(distinct(patient.id)) as counts, date_part('month', date_of_service) as month")}
  end

  scope :ordered, joins(:hospital_episodes).order("admit_date DESC")
  def validation_dob
    self.errors.add(:date_of_birth, "invalid date") if self.date_of_birth > Date.today  unless self.date_of_birth.nil? 
  end
end
