require "social_feed_agregator/feed"
require 'twitter'

module SocialFeedAgregator
  class TwitterReader

    attr_accessor :consumer_key, 
                  :consumer_secret,
                  :twitter_oauth_token,
                  :twitter_oauth_token_secret,
                  :twitter_name

    def initialize(options={})
      options.replace(SocialFeedAgregator.default_options.merge(options))

      @consumer_key = options[:twitter_consumer_key]
      @consumer_secret = options[:twitter_consumer_secret]
      @oauth_token = options[:twitter_oauth_token]
      @token_secret = options[:twitter_oauth_token_secret]
      @name = options[:twitter_user_name]
    end
        
    def get_feeds(options={})
      @name = options[:name] if options[:name]
      count = options[:count] if options[:count]
      
      client = Twitter.configure do |config|
        config.consumer_key = @consumer_key
        config.consumer_secret = @consumer_secret
        config.oauth_token = @oauth_token
        config.oauth_token_secret = @token_secret
      end
          
      statuses = client.user_timeline(@name, {count: count})
    
      statuses.map do |status|        
        puts status.inspect

        Feed.new ({
          feed_type: :twitter,
          feed_id: status.id.to_s,       

          user_id: status.user.id,
          user_name: status.user.screen_name,
          
          permalink: "https://twitter.com/#{status.user.screen_name}/status/#{status.id.to_s}",
          message: status.text,          
          created_at: status.created_at,

          description: status.user.description,
        })                
      end       

    end
   
  end
end