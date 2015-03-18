class CreateSuperbillModifiers < ActiveRecord::Migration
  def self.up

    create_table :superbill_modifiers do |t|
      t.integer :superbill_id
      t.integer :modifier_id
      t.integer :display_order
      t.timestamps
    end

    drop_table :superbill_cpt_modifier

  end

  def self.down
    drop_table :superbill_modifiers
    create_table :superbill_cpt_modifier do |t|
      t.integer :superbill_cpt_id
      t.integer :display_order
      t.string :modifier
      t.text :description
      t.timestamps
    end
  end
end
