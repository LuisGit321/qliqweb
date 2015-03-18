class ChangeBillingPref < ActiveRecord::Migration
  def self.up
    remove_column :billing_pref, :resource_id
    remove_column :billing_pref, :resource_type
    add_column :billing_pref, :physician_group_id, :integer
  end

  def self.down
    remove_column :billing_pref, :physician_group_id
    add_column :billing_pref, :resource_id, :integer
    add_column :billing_pref, :resource_type, :string
  end
end
