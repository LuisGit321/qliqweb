class AddPhysicianItselfToPhysicianGroup < ActiveRecord::Migration
  def self.up
    add_column :physician_group, :physician_itself, :boolean , :default => false
  end

  def self.down
    remove_column :physician_group, :physician_itself
  end
end
