# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
#
Role.create(:name => "System Admin")
Role.create(:name => "Group Admin")
Role.create(:name => "Billing Admin")
Role.create(:name => "Billing Funcational")
Role.create(:name => "Physician Admin")
Role.create(:name => "Physician Funcational")
