class HospitalEpisode < ActiveRecord::Base
  set_primary_key :patient_id
  set_table_name 'hospital_episode'

  belongs_to :referring_physician, :class_name => 'ReferringPhysician', :foreign_key => :primary_physician_id
  belongs_to :patient, :class_name => 'Patient', :foreign_key => :patient_id
  belongs_to :referring_physician, :class_name => 'ReferringPhysician', :foreign_key => :referring_physician_id

  def self.before_save
    self.admit_date = Date.today
  end
  
  
  if Rails.env == "development" || Rails.env == "test"
    scope :referral_volume, lambda{|physicians, start_date, end_date| where("(primary_physician_id in (?) or referring_physician_id in (?)) and (admit_date >= ? and admit_date <= ?)", physicians, physicians, start_date, end_date).joins("INNER JOIN 'referring_physician' ON referring_physician.id = hospital_episode.primary_physician_id or referring_physician.id=hospital_episode.referring_physician_id").group("strftime('%m', admit_date), referring_physician.name").select("referring_physician.name, referring_physician.id as rid, count(id) as ref_count, strftime('%m', admit_date) as month, admit_date")}
  else
    scope :referral_volume, lambda{|physicians, start_date, end_date| where("(primary_physician_id in (?) or referring_physician_id in (?)) and (admit_date >= ? and admit_date <= ?)", physicians, physicians, start_date, end_date).joins("INNER JOIN referring_physician ON referring_physician.id = hospital_episode.primary_physician_id or referring_physician.id = hospital_episode.referring_physician_id").group("date_part('month', admit_date), referring_physician.name, referring_physician.id, admit_date").select("referring_physician.name, referring_physician.id as rid, count(id) as ref_count, date_part('month', admit_date) as month, admit_date")}
  end
end
