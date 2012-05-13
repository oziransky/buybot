class Facebook

  class << self

    private

    def init_config
      @config ||= YAML.load_file("#{Rails.root}/config/facebook.yml")[Rails.env].symbolize_keys
    end
    public

    def app

      init_config

      fb_auth = FbGraph::Auth.new(@config[:client_id], @config[:client_secret])

      fb_auth.client.redirect_uri = @config[:redirect_uri]
      fb_auth.client
    end

    def profile(access_token)
      profile = FbGraph::User.me(access_token).fetch
    end

    def scope
      @config[:scope] unless @config.nil?
    end
  end
end
