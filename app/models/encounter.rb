class Encounter < ActiveRecord::Base
  set_table_name 'encounter'
  has_many :billing_batches, :class_name => 'BillingBatch'
  belongs_to :note, :class_name => 'Note', :foreign_key => :note_id
  belongs_to :physician, :class_name => 'Physician', :foreign_key => :physician_id
  belongs_to :patient, :class_name => 'Patient', :foreign_key => :patient_id
  has_many :encounter_cpts, :class_name => 'EncounterCpt', :dependent => :destroy
  has_many :encounter_icds, :class_name => 'EncounterIcd', :dependent => :destroy
  has_many :encounter_notes, :class_name => 'EncounterNote', :dependent => :destroy
  has_many :notes, :through => :encounter_notes, :source => :note, :dependent => :destroy
  has_many :cpts, :through => :encounter_cpts, :source => :superbill_cpt, :order => "encounter_cpt.updated_at DESC"

  attr_accessor :error_cpt_codes, :error_icd_codes

  accepts_nested_attributes_for :encounter_cpts, :allow_destroy => true, :reject_if => :reject_encounter_cpts 
  accepts_nested_attributes_for :encounter_icds, :allow_destroy => true, :reject_if => :reject_encounter_icds 
  accepts_nested_attributes_for :encounter_notes, :allow_destroy => true
  
  validates :physician_id, :presence => true
  validates :date_of_service, :presence => true

  #validate :validate_icds
  validate :validate_cpts
  validate :validation_date_of_service

  scope :for_dot, lambda {|patient_id, dot| {:conditions => ["patient_id = ? and date_of_service = ?", patient_id.to_i, dot]}}
  scope :unbilled, joins(:encounter_cpts).where("processed_date is NULL and encounter_cpt.id is not NULL")
  scope :physician_billings, lambda { |physician| where("physician_id = ? and processed_date >= ?", physician,Date.today - 1.day).group(:processed_date).select("processed_date").order("processed_date DESC")} 
  scope :by_processed_date, lambda {|processed_date| where("processed_date = ?", processed_date)}

  if Rails.env == "development" || Rails.env == "test"
    scope :monthly_encounters, lambda{|physicians, start_date, end_date| joins(:patient => [:physician]).where("physician.id in (?) and (date_of_service >= ? and date_of_service <= ?)", physicians, start_date, end_date).group("strftime('%m', date_of_service)").select("count(distinct(encounter.id)) as counts, strftime('%m', date_of_service) as month")}
  else 
    scope :monthly_encounters, lambda{|physicians, start_date, end_date| joins(:patient => [:physician]).where("physician.id in (?) and (date_of_service >= ? and date_of_service <= ?)", physicians, start_date, end_date).group("date_part('month', date_of_service)").select("count(distinct(encounter.id)) as counts, date_part('month', date_of_service) as month")}
  end

  def reject_encounter_icds(attributed)
    attributed['icd_id'].blank? || self.encounter_icds.collect(&:icd_id).include?(attributed['icd_id'].to_i) 
  end

  def reject_encounter_cpts(attributed)
    attributed['superbill_cpt_id'].blank? || self.encounter_cpts.collect(&:superbill_cpt_id).include?(attributed['superbill_cpt_id'].to_i) 
  end

  def validate_cpts
    self.errors.add(:error_cpt_codes, "Please enter at least 1 procedure code") if self.encounter_cpts.empty?
  end

  def validate_icds
    self.errors.add(:error_icd_codes, "Please enter at least 1 diagnosis code") if self.encounter_icds.empty?
  end
  
  def validation_date_of_service
    self.errors.add(:date_of_service, "invalid date") if self.date_of_service > Date.today  unless self.date_of_service.nil? 
  end

  def validate_date_of_service(session)
    if !session[:encounters].nil? && !self.date_of_service.nil?
      if session[:encounters].keys.include?(self.date_of_service.strftime("%Y/%m/%d"))
        self.errors.add(:date_of_service, "already taken") 
      end
    elsif !self.patient_id.nil? && !self.date_of_service.nil?
      self.errors.add(:date_of_service, "already taken") unless Encounter.for_dot(self.patient_id, self.date_of_service.strftime("%Y-%m-%d")).empty?
    end
    self.errors.empty?
  end
end
