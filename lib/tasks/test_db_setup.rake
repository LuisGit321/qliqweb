desc "Setup test database - drops, loads schema, migrates and seeds the test db"
task :test_db_setup  do
  db_config = YAML.load_file(File.join(Rails.root, "config", "database.yml"))
  Rails.env = ENV['RAILS_ENV'] = 'test'
  Rake::Task['db:drop'].invoke
  Rake::Task['db:create'].invoke
  system  "mysql --force  -u#{db_config['test']['username']} -p -p #{db_config['test']['database']}< db/sql/data.sql"
  ActiveRecord::Base.establish_connection
  Rake::Task['db:migrate'].invoke
  Rake::Task['db:seed'].invoke

end
