class ChangeBillingAgency < ActiveRecord::Migration
  def self.up
    add_column :billing_agency, :first_name, :string
    add_column :billing_agency, :last_name, :string
    remove_column :billing_agency, :name
  end

  def self.down
    remove_column :billing_agency, :first_name, :string
    remove_column :billing_agency, :last_name, :string
    add_column :billing_agency, :name
  end
end
