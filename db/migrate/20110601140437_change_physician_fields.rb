class ChangePhysicianFields < ActiveRecord::Migration
  def self.up
    add_column :physician, :first_name, :string
    add_column :physician, :last_name, :string
    remove_column :physician, :name
  end

  def self.down
    add_column :physician, :name, :string
    remove_column :physician, :first_name
    remove_column :physician, :last_name
  end
end
