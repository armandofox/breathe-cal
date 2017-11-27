class User < ActiveRecord::Base
    has_many :cities
    has_many :markers
    validates :provider, :uid, :name, :email, :oauth_token, presence: true
    validates :oauth_expires_at, presence: true, if: :not_expired?

    geocoded_by :address
    after_validation :geocode
    serialize :searches, JSON
    
    # During Authentication, checks if user already exists in the database else
    # it creates a new user entry. If a user exists it updates its the user's
    # information from info returned by auth_hash
    def self.find_or_create_from_auth_hash(auth)
       user = find_by(provider: auth[:provider], uid: auth[:uid])
       if user
            user.assign_attributes(auth_data(auth))
            user.save
            return user
       else
           create_user_from_omniauth(auth)
       end
    end
    
    # Creates a user if it doesn't exist in the database
    def self.create_user_from_omniauth(auth)
        create(auth_data(auth))
    end
    
    # Grabs needed information from the auth hash for user creation/update
    def self.auth_data(auth)
        {provider: auth[:provider], 
        uid: auth[:uid],
        name: auth[:info][:name],
        email: auth[:info][:email],
        oauth_token: auth[:credentials][:token],
        oauth_expires_at: Time.at(auth[:credentials][:expires_at])}
    end
    
    # Checks to see if authorization has not expired
    def not_expired?
        if self[:oauth_expires_at]
            self[:oauth_expires_at] > Time.now
        else
            nil
        end
    end
    
end 
