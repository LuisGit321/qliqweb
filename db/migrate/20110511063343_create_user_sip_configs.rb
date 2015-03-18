class CreateUserSipConfigs < ActiveRecord::Migration
  def self.up
    create_table :user_sip_configs do |t|
      t.integer :user_id
      t.string :display_name
      t.string :sip_uri
      t.string :public_key
      t.timestamps
    end
  end

  def self.down
    drop_table :user_sip_configs
  end
end
