#NOTE WE MAY BE ABLE TO USE THIS LATER BUT FIRGGING CAPYBARA IS HAVING ISSUES WITH SELENIUM THAT I CANT FIX -JS

# require 'active_support/core_ext/numeric/time.rb'

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