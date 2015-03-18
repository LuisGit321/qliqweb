namespace :db do
  namespace :migrate do
    desc "creation of super admin user"
    task :create_super_admin => :environment do
      user = User.new(:email => "sethu@joshsoftware.com", :password => "admin123", :username => "admin", :resource_type => "Super Admin")
      user.roles = ["System Admin"]
      user.save!
      user.confirm!
    end
  end
end
