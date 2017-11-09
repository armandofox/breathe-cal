class User < ActiveRecord::Base
    has_many :cities

    geocoded_by :address
    after_validation :geocode
    serialize :searches, JSON
    
    def self.find_or_create_from_auth_hash(auth)
       user = find_by(provider: auth[:provider], uid: auth[:uid])
       if user
            user.assign_attributes(provider: auth[:provider], 
                uid: auth[:uid],
                name: auth[:info][:name],
                email: auth[:info][:email],
                oauth_token: auth[:credentials][:token],
                oauth_expires_at: Time.at(auth[:credentials][:expires_at]))
            user.save
       else
           create_user_from_omniauth(auth)
       end
    end
    
    def self.create_user_from_omniauth(auth)
        create(provider: auth[:provider], 
               uid: auth[:uid],
               name: auth[:info][:name],
               email: auth[:info][:email],
               oauth_token: auth[:credentials][:token],
               oauth_expires_at: Time.at(auth[:credentials][:expires_at])
               )
    end
    
    def is_valid?
        provider && oauth_token && oauth_expires_at && oauth_expires_at > Time.now
    end
    
end 
