class AddNewFieldInPhysicianGroup < ActiveRecord::Migration
  def self.up
    add_column :physician_group, :first_name, :string
    add_column :physician_group, :last_name, :string
    add_column :physician_group, :company, :string
    add_column :physician_group, :address2, :string
    add_column :physician_group, :providers, :integer
  end
  
  def self.down
    remove_column :physician_groups, :first_name
    remove_column :physician_groups, :last_name
    remove_column :physician_groups, :company
    remove_column :physician_groups, :address2
    remove_column :physician_groups, :providers
  end
end
