#-------------------------------------------------------------------------------
# OMNIAUTH TESTING : https://github.com/omniauth/omniauth/wiki/Integration-Testing
#-------------------------------------------------------------------------------

# Turns on OmniAuth testing mode for authentication
# Ensures authentication failures are directed to auth/failure
# Provides a default user_hash for creating new users
Before('@omniauth_google_login') do
    OmniAuth.config.test_mode = true
    OmniAuth.config.on_failure = Proc.new { |env|
        OmniAuth::FailureEndpoint.new(env).redirect_to_failure
    }
    @user_hash = {
        provider: 'google_oauth2', 
        uid: 101,
        info: {name: "test user", email: "test@xxxx.com"},
        credentials: {token: 'some_token', expires_at: Time.now + 10.day}
      }
end

# Turns off OmniAuth testing mode for authentication
# Reset's omniauth to a consistent state between tests
After('@omniauth_google_login') do
    OmniAuth.config.mock_auth[:google_oauth2] = nil
    OmniAuth.config.test_mode = false
end




# # Ensures that valid credentials are returned if calls are made to any provider
# Before('@omniauth_login_success') do
#     OmniAuth.config.test_mode = true

#     # the symbol passed to mock_auth is the same as the name of the provider set up in the initializer
#     OmniAuth.config.mock_auth[:google] = {
#         "provider"=>"google_oauth2",
#         "uid"=>"http://xxxx.com/openid?id=118181138998978630963",
#         "info"=>{"email"=>"test@xxxx.com", "name"=>"Test User"},
#         "credentials" => {"token"=> "XYZ123", "expires_at"=>Time.at(Time.now + 3.days)}
#     }
# end

# After('@omniauth_login_success') do
#     OmniAuth.config.test_mode = false
# end

# # Capybara cannot access HTTP resources outside the rack application therefore
# # For tests that require logging in we need to switch the driver to selenium
# # For More Info https://github.com/teamcapybara/capybara#drivers
# Before('@omniauth') do
#     Capybara.current_driver = :webkit
# end

# After('@omniauth') do
#     Capybara.use_default_driver
# end