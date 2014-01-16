require "clockwork"
require "hntrendz/jobs/handler"

module Clockwork

  configure do |config|
    config[:thread] = true
    config[:max_threads] = 5
  end
  
  handler do |job|
    Hntrendz::Jobs::Handler.execute(job)
  end

  every(5.minutes, 'update_hn_stories')

end
