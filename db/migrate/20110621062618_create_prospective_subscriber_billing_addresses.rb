class CreateProspectiveSubscriberBillingAddresses < ActiveRecord::Migration
  def self.up
    create_table :prospective_subscriber_billing_addresses do |t|
      t.integer :prospective_subscriber_id
      t.string :first_name
      t.string :last_name
      t.string :title
      t.string :phone
      t.string :email
      t.string :company
      t.string :address1
      t.string :address2
      t.string :city
      t.string :state
      t.string :zip
      t.timestamps
    end
  end

  def self.down
    drop_table :prospective_subscriber_billing_addresses
  end
end
