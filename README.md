# SocialFeedAgregator

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'social_feed_agregator'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install social_feed_agregator

## Usage

    ## 1. Create reader for some social service (available Facebook, Twitter, Pinterest)

    fb = SFA::Facebook.new ({      
      facebook_app_id:            "FACEBOOK_APP_ID", 
      facebook_app_secret:        "FACEBOOK_APP_SECRET",  
      facebook_user_name:         "FACEBOOK_USER_NAME"
    })

    tw = SFA::Twitter.new ({      
      twitter_consumer_key:       "TWITTER_CONSUMER_KEY", 
      twitter_consumer_secret:    "TWITTER_CONSUMER_SECRET",
      twitter_oauth_token:        "TWITTER_OAUTH_TOKEN",
      twitter_oauth_token_secret: "TWITTER_OAUTH_TOKEN_SECRET",
      twitter_user_name:          "TWITTER_USER_NAME"      
    })

    pins = SFA::Pinterest.new ({
      pinterest_user_name:        "PINTEREST_USER_NAME"
    })


    ## 2. Get data

    res = []
        
    # Default 25
    fb.get_feeds(count: 2) do |feed|
      res << feed
    end

    # Default 25
    tw.get_feeds(count: 2) do |feed|
      res << feed
    end

    # Default 25
    pins.get_feeds(count: 2) do |feed|
      res << feed
    end

    res.sort!{|a, b| a.created_at <=> b.created_at}

    res.to_json

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
