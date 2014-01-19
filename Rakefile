require "bundler/gem_tasks"

task :reset_db do
  require "sequel"
  db = Sequel.connect('sqlite://db/hntrendz.db')
  puts "Emptying post_trend and posts tables.."
  db.transaction do
    db[:post_trend].delete
    db[:posts].delete
  end
  puts "done!"
end
