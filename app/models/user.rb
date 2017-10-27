class User < ActiveRecord::Base
    has_many :cities 

    geocoded_by :address
    after_validation :geocode
    serialize :searches, JSON
    
    def self.find_or_create_from_auth_hash(auth)
        find_by(provider: auth[:provider], uid: auth[:uid]) || create_user_from_omniauth(auth)
    end
    
    def self.create_user_from_omniauth(auth)
        create(provider: auth[:provider], 
               uid: auth[:uid],
               name: auth[:info][:name],
               oauth_token: auth[:credentials][:token],
               oauth_expires_at: Time.at(auth[:credentials][:expires_at])
               )
    end
end 
