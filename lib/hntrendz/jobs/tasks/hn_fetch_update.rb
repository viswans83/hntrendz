require "date"
require "set"
require "sequel"
require "hnposts"

module Hntrendz
  
  module Jobs
    
    class HNFetchAndUpdateJob

      attr_accessor :timestamp, :posts

      def self.db_path
        File.join(File.dirname(__FILE__),'../../../../','db/hntrendz.db')
      end

      DB = Sequel.connect("sqlite://#{db_path}")

      def execute
        self.timestamp = DateTime.now

        self.posts = HNPosts.fetch_posts
        
        DB.transaction do
          insert_new_posts
          update_trends_for_posts
          stop_tracking_stale_posts
        end
      end

      def post_ids
        @post_ids ||= posts.map { |p| p.post_id }
      end

      def posts_hash
        @posts_hash ||= Hash[ posts.map {|p| [p.post_id,p]} ]
      end

      def post_entity_ids post_entities
        post_entities.map { |pe| pe[:id] }
      end
      
      def new_posts
        @new_posts ||= begin
          (post_ids - existing_post_ids).map do |post_id|
            posts_hash[post_id]
          end
        end
      end

      def existing_post_ids
        @existing_posts ||= begin
          post_entity_ids DB[:posts].select(:id).where(:id => post_ids).all
        end
      end

      def stale_post_ids
        @stale_post_ids ||= begin
          trending_post_ids - post_ids
        end
      end
      
      def trending_post_ids
        @trending_post_ids ||= begin
          post_entity_ids DB[:posts].select(:id).where(:track_end => nil).all
        end
      end
      
      def insert_new_posts
        new_posts.each do |p|
          DB[:posts].insert(:id => p.post_id,
                            :title => p.title,
                            :url => p.url,
                            :track_start => timestamp)
        end unless new_posts.empty?
      end

      def update_trends_for_posts
        posts.each do |p|
          DB[:post_trend].insert(:post_id => p.post_id,
                                 :time_stamp => timestamp,
                                 :position => p.position,
                                 :points => p.points,
                                 :comments => p.comments)
        end
      end

      def stop_tracking_stale_posts
        DB[:posts]
          .where(:id => stale_post_ids)
          .update(:track_end => timestamp) unless stale_post_ids.empty?
      end
      
    end
    
  end
end
