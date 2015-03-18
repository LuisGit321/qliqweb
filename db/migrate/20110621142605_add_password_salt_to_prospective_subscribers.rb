class AddPasswordSaltToProspectiveSubscribers < ActiveRecord::Migration
  def self.up
    add_column :prospective_subscribers, :password_salt, :string, :limit => 128, :default => ""
  end

  def self.down
    remove_column :prospective_subscribers, :password_salt
  end
end
