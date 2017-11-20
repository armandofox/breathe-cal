FactoryGirl.define do
  factory :user do
    name 'John Smith' # default values
    provider 'google_oauth2'
    uid 101
    id 1
    email "test@xxxx.com"
    oauth_token 'some_token'
    oauth_expires_at Time.now + 10.day
  end
end