class CreateProspectiveSubscribers < ActiveRecord::Migration
  def self.up
    create_table :prospective_subscribers do |t|
      t.string :email
      t.string :password
      t.integer :passed_step
      t.timestamps
    end
  end

  def self.down
    drop_table :prospective_subscribers
  end
end
