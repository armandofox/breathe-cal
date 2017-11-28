require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
    controller do
        def index
          render :nothing => true
        end
    end

    describe " filter require_login" do
        it "calls a function to retrieve a real or guest user model" do
            expect(controller).to receive(:current_or_guest_user)
            get :index
        end
        it "redirects to error page when server cannot login user" do
            expect(controller).to receive(:current_or_guest_user).and_return(nil)
            get :index
            expect(response).to render_template("error_pages/500")
        end
    end
    
    describe " guest_user" do
        before :each do
            @fake_guest_user = User.new(name: "guest")
            @fake_guest_user.save!(:validate => false)
        end
        it "creates a guest user if no guest user is logged in" do
            allow(controller).to receive(:create_guest_user).and_return(@fake_guest_user)
            expect(controller.guest_user).to eq(@fake_guest_user)
        end
        it "returns current guest user if they are signed in" do
            session[:guest_user_id] = @fake_guest_user.id
            allow(controller).to receive(:create_guest_user).and_return(nil)
            expect(controller.guest_user).to eq(@fake_guest_user)
        end
        it "sets guest_user and guest_user_id to nil if guest user creation fails" do
            allow(controller).to receive(:create_guest_user).and_return(double("User", :id => -1))
            expect(controller.guest_user).to eq(nil)
            expect(session[:guest_user_id]).to eq(nil)
        end
    end
    
    describe " current_or_guest_user" do
        before :each do
            @fake_user = FactoryBot.build(:user)
            @fake_guest_user = FactoryBot.build(:user, :name => 'Guest')
        end
        describe " current_user exists" do
            before :each do
                expect(controller).to receive(:current_user).at_least(:once).and_return(@fake_user)
            end
            it "returns a real user" do
                get :index
                expect(assigns(:current_or_guest_user)).to eq(@fake_user)
            end
            it "merges data from a guest user into real user and deletes guest" do
                expect(controller).to receive(:guest_user).at_least(:once).and_return(@fake_guest_user)
                expect(controller).to receive(:logging_in)
                expect(@fake_guest_user).to receive(:destroy).and_return(@fake_guest_user)
                expect(@fake_guest_user).to receive(:reload).and_return(@fake_guest_user)
                session[:user_id] = 1
                session[:guest_user_id] = 2
                get :index
            end
        end
        
        describe " current_user doesn't exists" do
            before :each do
                allow(controller).to receive(:current_user).at_least(:once).and_return(nil)
                expect(controller).to receive(:guest_user).at_least(:once).and_return(@fake_guest_user)
            end
            it "returns a guest user" do
                get :index
                expect(assigns(:current_or_guest_user)).to eq(@fake_guest_user)
            end
        end
    end
end