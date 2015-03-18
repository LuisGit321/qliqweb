class AddCreatedAndUpdatedToPhysicianGroups < ActiveRecord::Migration
  def self.up
    add_column :physician_group, :created_at, :datetime
    add_column :physician_group, :updated_at, :datetime
  end

  def self.down
    remove_column :physician_group, :updated_at
    remove_column :physician_group, :created_at
  end
end
