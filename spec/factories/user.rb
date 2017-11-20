FactoryGirl.define do
  factory :User do
    name 'John Smith' # default values
    provider 'google_oauth2'
    uid 101
    email "test@xxxx.com"
    oauth_token 'some_token'
    oauth_expires_at Time.now + 10.day
  end
end