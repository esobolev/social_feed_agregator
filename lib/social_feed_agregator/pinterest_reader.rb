require "social_feed_agregator/feed"

module SocialFeedAgregator
  class PinterestReader

    attr_accessor :name

    def initialize(options={})
      options.replace(SocialFeedAgregator.default_options.merge(options))
      @name = options[:pinterest_user_name]      
    end
        
    def get_feeds(options={})
      @name = options[:name] if options[:name]

      doc = Nokogiri::XML(RestClient.get("http://pinterest.com/#{@name}/feed.rss"))                       

      doc.xpath('//item').map do |item|

        desc = item.xpath('description').inner_text.match(/src="(\S+)".+<p>(.+)<\/p>/)
        
        Feed.new ({          
          feed_type: :pinterest,
          feed_id: item.xpath('guid').inner_text.match(/\d+/)[0].to_s,

          user_id: @name,
          user_name: @name,

          name: item.xpath('title').inner_text,          
          permalink: item.xpath('link').inner_text,
          picture_url: desc[1],
          description: desc[2],
          created_at: DateTime.parse(item.xpath('pubDate').inner_text), #.strftime("%Y-%m-%d %H:%M:%S")
        })  
      end
    end   
  end
  Pinterest = PinterestReader
end