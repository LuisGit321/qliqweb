class AddPaidToPhysicianGroup < ActiveRecord::Migration
  def self.up
    add_column :physician_group, :paid, :boolean, :default => false
  end

  def self.down
    remove_column :physician_group, :paid
  end
end
