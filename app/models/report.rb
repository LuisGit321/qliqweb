class Report < ActiveRecord::Base
  def self.columns() @columns ||= []; end
  def self.column(name, sql_type = nil, default = nil, null = true)
    columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s, default, sql_type.to_s, null)
  end

  attr_accessor :activity_log

  column :physician_id, :integer
  column :referring_physician_id, :integer
  column :start_date, :date
  column :end_date, :date

  validates :physician_id, :presence => true, :unless => :is_active_log? 
  validates :start_date, :presence => true
  validates :end_date, :presence => true

  def is_active_log?
    self.activity_log.blank? 
  end
end

class BillingPatient < ActiveRecord::Base
  def self.columns() @columns ||= []; end
  def self.column(name, sql_type = nil, default = nil, null = true)
    columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s, default, sql_type.to_s, null)
  end

  column :physician, :integer
  column :group, :integer
end
