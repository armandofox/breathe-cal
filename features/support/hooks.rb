require 'active_support/core_ext/numeric/time.rb'

# Ensures that valid credentials are returned if calls are made to any provider
Before('@omniauth_login_success') do
    OmniAuth.config.test_mode = true

    # the symbol passed to mock_auth is the same as the name of the provider set up in the initializer
    OmniAuth.config.mock_auth[:google] = {
        "provider"=>"google_oauth2",
        "uid"=>"http://xxxx.com/openid?id=118181138998978630963",
        "info"=>{"email"=>"test@xxxx.com", "name"=>"Test User"},
        "credentials" => {"token"=> "XYZ123", "expires_at"=>Time.at(Time.now + 3.days)}
    }
end

After('@omniauth_login_success') do
    OmniAuth.config.test_mode = false
end