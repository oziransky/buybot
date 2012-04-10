class Facebook
  # To change this template use File | Settings | File Templates.

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
      if @profile.nil? or @profile.access.access_token == access_token
        @profile = FbGraph::User.me(access_token).fetch
      else
        @profile
      end

    end

  end
end