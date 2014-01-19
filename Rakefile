require "bundler/gem_tasks"

task :reset_db do
  require "sequel"
  db = Sequel.connect('sqlite://db/hntrendz.db')
  db.transaction do
    db[:post_trend].delete
    db[:posts].delete
  end
end
