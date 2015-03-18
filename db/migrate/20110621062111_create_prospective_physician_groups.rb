class CreateProspectivePhysicianGroups < ActiveRecord::Migration
  def self.up
    create_table :prospective_physician_groups do |t|
      t.integer :prospective_subscriber_id
      t.string :name, :limit => 50
      t.string :address, :limit => 50
      t.string :city, :limit => 50
      t.string :state, :limit => 5
      t.string :zip, :limit => 10
      t.string :phone, :limit => 25
      t.string :fax, :limit => 15
      t.string :admin_email, :limit => 50
      t.string :admin_password, :limit => 50
      t.boolean :is_user_required, :default => false
      t.integer :print_id
      t.string :first_name
      t.string :last_name
      t.string :company
      t.string :address2
      t.integer :providers
      t.boolean :paid, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :prospective_physician_groups
  end
end
