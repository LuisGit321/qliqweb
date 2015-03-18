class AddIsAccountInfoToProspectiveSubscriberBillingAddress < ActiveRecord::Migration
  def self.up
    add_column :prospective_subscriber_billing_addresses, :is_account_info, :boolean, :default => false
  end

  def self.down
    remove_column :prospective_subscriber_billing_addresses, :is_account_info
  end
end
