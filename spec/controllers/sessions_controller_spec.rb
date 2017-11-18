require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
    
    # for documentation on OmniAuth Test mode visit https://github.com/omniauth/omniauth/wiki/Integration-Testing
    before :each do
        OmniAuth.config.test_mode = true
        @user_hash = {
            provider: 'google_oauth2', 
            uid: 101,
            info: {name: "test user", email: "test@xxxx.com"},
            credentials: {token: 'some_token', expires_at: (Time.now + 10.day).round}
        }
        OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(@user_hash)
        Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:google_oauth2]
        @user = instance_double("User")
        allow(@user).to receive(:id).and_return(101)
    end
    
    after :each do
        OmniAuth.config.mock_auth[:google_oauth2] = nil
        OmniAuth.config.test_mode = false
    end
    # before { controller.instance_variable_set(:@authauth, nil) } 
    describe "#auth_hash" do
        it "looks for hash in memory" do
            allow(User).to receive(:find_or_create_from_auth_hash).and_return(@user)
            expect(controller).to receive(:auth_hash)
            post :create
        end
    end

    describe "#create" do
        it "Tries to find or create a new user" do
            expect(User).to receive(:find_or_create_from_auth_hash).with(OmniAuth.config.mock_auth[:google_oauth2]).and_return(@user)
            post :create
            #expect(assigns(:current_user)).to eq("test user")
        end
        it "Can find an existing user and update its record" do
            expect(@user).to receive(:assign_attributes)
            expect(@user).to receive(:save)
            expect(User).to receive(:find_by).with(provider: 'google_oauth2', uid: 101).and_return(@user)
            post :create
            # expect(assigns(:current_user)).to eq("test user")
        end
        it "creates a new user" do
            expect(User).to receive(:create_user_from_omniauth).with(OmniAuth.config.mock_auth[:google_oauth2]).and_return(@user)
            post :create
            # expect(assigns(:current_user)).to eq("test user")
        end
        it "sets the session hash to the user id" do
            allow(User).to receive(:create_user_from_omniauth).with(OmniAuth.config.mock_auth[:google_oauth2]).and_return(@user)
            post :create
            expect(session[:user_id]).to eq(101)
        end
    end

    describe "#destroy" do
        it "Logs out current user" do
            delete :destroy
            expect(session[:user_id]).to eq(nil)
            response.should redirect_to root_path
        end
    end
    
    describe "#auth_failure" do
        it "sets an error message" do
            get :auth_failure
            expect(flash[:auth_failure]).to eq("Failed to Login")
            response.should redirect_to root_path
        end
    end
end
