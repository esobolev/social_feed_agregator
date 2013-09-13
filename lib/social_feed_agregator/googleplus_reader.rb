require "social_feed_agregator/base_reader"
require "social_feed_agregator/feed"

module SocialFeedAgregator
  class GoogleplusReader < BaseReader

    attr_accessor :api_key, :user_id

    def initialize(options={})
      super(options)
      options.replace(SFA.default_options.merge(options))

      @user_id = options[:googleplus_user_id]
      @api_key = options[:googleplus_api_key]
    end
        
    def get_feeds(options={}) 
      super(options)
      @user_id = options[:user_id] if options[:user_id]
      count = options[:count] || 25
      
      feeds, i, count_per_request, items = [], 0, 100, 0

      opts =  {count: count < count_per_request ? count : count_per_request}

      parts = (count.to_f / count_per_request).ceil

      url = "https://www.googleapis.com/plus/v1/people/#{@user_id}/activities/public?key=#{@api_key}&maxResults=#{opts[:count]}"      

      begin
        i+=1
        next_query = ""
        data = JSON.parse( RestClient.get("#{url}#{next_query}") )

        data['items'].each do |post|    
          items+=1
          break if items > count          

          feed = fill_feed post

          block_given? ? yield(feed) : feeds << feed        
        end       
        next_query = "&pageToken=#{data['nextPageToken']}"
        
      end while (data['items'].count > 0 ) && (i < parts)      
    end   

    private
    def fill_feed(post)
      picture_url, link, caption = "", "", ""

      if atts = post['object']['attachments']
        if atts.count > 0              
          attach = atts.first
          picture_url = attach['fullImage']['url'] if attach['fullImage']
          link = attach['url']
          caption = attach['displayName']
        end
      end

      Feed.new(
        feed_type: :googleplus,
        feed_id: post['id'],
        
        user_id: post['actor']['id'],
        user_name: post['actor']['displayName'],
        
        permalink: post['url'],
        description: post['object']['content'],

        name: post['title'],

        picture_url: picture_url,
        link: link,
        # caption: caption,
        
        created_at: DateTime.parse(post['published']),
        type: post['object']['objectType']
      )
    end
  end
  Googleplus = GoogleplusReader
end