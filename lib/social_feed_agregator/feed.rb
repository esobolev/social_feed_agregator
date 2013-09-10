module SocialFeedAgregator
  class Feed

    attr_accessor :feed_type,      # :facebook, :twitter or :linkedin
                  :feed_id,        # origin feed id
                  :user_id,        # user id
                  :user_name,      # user name
                  :permalink,      
                  :description,    
                  :picture_url,    
                  :name,
                  :link, 
                  # :story, 
                  :message,          # status message
                  :caption, 
                  :created_at, 
                  :type              # link or status
    
    def initialize(options={}) 
      @feed_type = options[:feed_type]
      @feed_id =   options[:feed_id]

      @user_id =   options[:user_id]      
      @user_name = options[:user_name]
      
      @permalink =   options[:permalink]
      @description = options[:description]
      @picture_url = options[:picture_url]

      @name  = options[:name]
      @link  = options[:link]
      # @story = options[:story]
      @message = options[:message]
      @caption = options[:caption]
      @created_at = options[:created_at]
      @type = options[:type]              
    end

  end
end