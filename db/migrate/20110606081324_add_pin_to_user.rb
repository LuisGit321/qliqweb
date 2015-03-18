class AddPinToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :pin, :string 
    add_column :users, :md5pin, :string 
  end

  def self.down
    remove_column :users, :pin, :string 
    remove_column :users, :md5pin, :string 
  end
end
