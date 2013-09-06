require "social_feed_agregator/base_reader"
require "social_feed_agregator/feed"

module SocialFeedAgregator
  class PinterestReader < BaseReader

    attr_accessor :name

    def initialize(options={})
      super(options)
      options.replace(SocialFeedAgregator.default_options.merge(options))
      @name = options[:pinterest_user_name]      
    end
        
    def get_feeds(options={})
      super(options)
      @name = options[:name] if options[:name]
      count = options[:count] || 25

      feeds, items = [], 0

      doc = Nokogiri::XML(RestClient.get("http://pinterest.com/#{@name}/feed.rss?page=2"))                       

      doc.xpath('//item').each do |item|
        items += 1
        break if items > count
        desc = item.xpath('description').inner_text.match(/src="(\S+)".+<p>(.+)<\/p>/)
        
        feed = Feed.new ({
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

        block_given? ? yield(feed) : feeds << feed
      end
      feeds
    end   
  end
  Pinterest = PinterestReader
end