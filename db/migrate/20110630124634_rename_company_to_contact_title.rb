class RenameCompanyToContactTitle < ActiveRecord::Migration
  def self.up
    rename_column :prospective_physician_groups, :company, :contact_title
    rename_column :physician_group, :company, :contact_title
  end

  def self.down
    rename_column :prospective_physician_groups, :contact_title, :company
    rename_column :physician_group, :contact_name,  :company
  end
end
