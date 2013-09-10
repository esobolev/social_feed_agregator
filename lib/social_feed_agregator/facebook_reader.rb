require "social_feed_agregator/base_reader"
require "social_feed_agregator/feed"
require "koala"

module SocialFeedAgregator
  class FacebookReader < BaseReader

    attr_accessor :app_id, :app_secret, :name

    def initialize(options={})
      super(options)
      options.replace(SFA.default_options.merge(options))

      @name =       options[:facebook_user_name]
      @app_id =     options[:facebook_app_id]
      @app_secret = options[:facebook_app_secret]      
    end    
        
    def get_feeds(options={})
      super(options)
      @name = options[:name] if options[:name]
      count = options[:count] || 25      
      
      feeds, i, count_per_request, items = [], 0, 25, 0

      parts = (count.to_f / count_per_request).ceil

      oauth = Koala::Facebook::OAuth.new(@app_id, @app_secret)      
      graph = Koala::Facebook::API.new oauth.get_app_access_token      
      posts = graph.get_connections(@name, "posts")

      begin
        i+=1
        posts.each do |post|    
          items+=1
          break if items > count

          feed = fill_feed post

          block_given? ? yield(feed) : feeds << feed          
        end       
      end while (posts = posts.next_page) && (i < parts)
      feeds
    end   

    private
  
    def fill_feed(post)
      Feed.new(
        feed_type: :facebook,
        feed_id: post['id'],                
        user_id: post['from']['id'],
        user_name: post['from']['name'],        
        permalink: "http://www.facebook.com/#{post['id'].gsub('_', '/posts/')}",
        description: post['description'],
        name: post['name'],
        picture_url: post['picture'],
        link: post['link'],
        caption: post['caption'],        
        message: post['message'],      
        created_at: DateTime.parse(post["created_time"]),
        type: post['type']
      )
    end

  end
  Facebook = FacebookReader
end