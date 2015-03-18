class BillingPref < ActiveRecord::Base
  set_table_name 'billing_pref'

  belongs_to :billing_agency
  belongs_to :physician_group

  validates :billing_agency_id, :physician_group_id, :presence => true

  attr_accessor :is_billing_exists
  #before_create :send_notification


  private

  def send_notification
    unless self.is_billing_exists.blank?
      Notifier.staff_added_notification(self.physician_group, self.billing_agency).deliver
    end
  end
end
