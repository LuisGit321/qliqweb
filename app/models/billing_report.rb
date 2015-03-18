class BillingReport < ActiveRecord::Base
  set_table_name 'billing_report'
  belongs_to :user
end
