class CreateBillingInfos < ActiveRecord::Migration
  def self.up
    create_table :billing_infos do |t|
      t.string :first_name
      t.string :last_name
      t.string :title
      t.string :phone
      t.string :email
      t.string :company
      t.string :address1
      t.string :address2
      t.string :city
      t.string :state
      t.string :zip
      t.string :credit_card_number
      t.integer :ex_month
      t.integer :ex_year
      t.integer :cvc_code 
      t.references :resource, :polymorphic => true      
      t.boolean :is_account_info, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :billing_infos
  end
end
