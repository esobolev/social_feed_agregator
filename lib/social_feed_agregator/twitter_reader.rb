require "social_feed_agregator/feed"
require "twitter"

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
      count = options[:count] || 20
      
      client = ::Twitter.configure do |config|
        config.consumer_key = @consumer_key
        config.consumer_secret = @consumer_secret
        config.oauth_token = @oauth_token
        config.oauth_token_secret = @token_secret
      end
          
          
      feeds, i = [], 0
      count_per_request =  200 #::Twitter::REST::API::Timelines::MAX_TWEETS_PER_REQUEST      

      opts = {count: count < count_per_request ? count : count_per_request}

      parts = (count.to_f / count_per_request).ceil

      while (statuses = client.user_timeline(@name, opts)) && i < parts do
        i+=1                

        statuses.each do |status|                
          tweet_type, picture_url, link  = 'status', '', ''

          # puts status.inspect
          # puts
           
          if status.entities?                      
            if status.media.any?
              photo_entity = status.media.first          
              tweet_type = 'photo'
              picture_url = photo_entity.media_url
            end

            if status.urls.any?
              url_entity = status.urls.first          
              tweet_type = 'link'
              link = url_entity.url
            end
          end

          feeds << Feed.new({
            feed_type: :twitter,
            feed_id: status.id.to_s,       

            user_id: status.user.id,
            user_name: status.user.screen_name,
            
            permalink: "https://twitter.com/#{status.user.screen_name}/status/#{status.id}", #status.url,
            message: status.text,          
            created_at: status.created_at,

            type: tweet_type,
            picture_url: picture_url,
            link: link
          })      
          
          new_count = count - count_per_request * i
          opts[:count] = new_count < count_per_request ? new_count : count_per_request
          opts[:max_id] = status.id.to_s          
        end       
      end
      feeds
    end
   
  end
  Twitter = TwitterReader
end