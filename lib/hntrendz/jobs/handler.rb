require "hntrendz/jobs/tasks/hn_fetch_update"

module Hntrendz
  module Jobs
    class Handler
      def self.execute job
        case job
        when 'update_hn_stories' then HNFetchAndUpdateJob.new.execute
        end
      end
    end
  end
end
