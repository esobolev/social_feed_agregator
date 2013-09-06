require "social_feed_agregator/version"
require "social_feed_agregator/facebook_reader"
require "social_feed_agregator/twitter_reader"
require "social_feed_agregator/pinterest_reader"

module SocialFeedAgregator  
  @default_options = {}
  class << self; attr_accessor :default_options; end

  class Exception < ::Exception; end  
end

SFA=SocialFeedAgregator