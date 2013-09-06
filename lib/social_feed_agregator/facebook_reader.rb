require "social_feed_agregator/feed"
require "koala"

module SocialFeedAgregator
  class FacebookReader

    attr_accessor :app_id, :app_secret, :name

    def initialize(options={})
      options.replace(SocialFeedAgregator.default_options.merge(options))

      @name =       options[:facebook_user_name]
      @app_id =     options[:facebook_app_id]
      @app_secret = options[:facebook_app_secret]      
    end
        
    def get_feeds(options={})
      @name = options[:name] if options[:name]

      oauth = Koala::Facebook::OAuth.new(@app_id, @app_secret)      
      graph = Koala::Facebook::API.new oauth.get_app_access_token      
      posts = graph.get_connections(@name, "posts")
      
      begin
        posts.map do |post|       
          Feed.new ({
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
            story: post['story'],
            message: post['message'],      
            created_at: post["created_time" ],
            type: post['type']
          })
        end       
      end while not posts = posts.next_page

    end
   
  end
end