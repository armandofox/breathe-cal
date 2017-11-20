require 'rails_helper'

RSpec.describe UsersController, type: :controller do
    
    before :each do
            session[:user_id] = 1
    end
    
    describe ' require_login filter' do
        it 'calls the function to check to see if user is logged in' do
            controller.should_receive(:require_login)
            controller.should_receive(:show)
            get :show, {:id => 1}
        end
        it 'sends non logged in users to homepage' do
            session[:user_id] = nil
            get :show, {:id => 1}
            expect(response).to redirect_to('/')
        end
        it 'sends a flash message to non logged in users requiring a sign in' do
            session[:user_id] = nil
            get :show, {:id => 1}
            expect(flash[:profile]).to eq("Cannot View Profile: Not Signed In")
        end
    end
    
    describe ' #show' do
        before :each do
            controller.class.skip_before_filter :require_login
            @fake_user = FactoryGirl.build(:user)
        end
        describe ' with invalid credentials' do
            before :each do
                get :show, {:id => 2}
            end
            it 'sends a flash message indicating invalid credentials' do
                expect(flash[:profile]).to eq("Cannot View Profile: Invalid UID")
            end
            it 'redirects user to the homepage' do
                expect(response).to redirect_to('/')
            end
        end
        
        describe ' with valid credentials' do
            before :each do
                expect(User).to receive(:find).with(1).and_return(@fake_user)
                get :show, {:id => 1}
            end
            it 'feeds user data to the view' do
                expect(assigns(:user)).to eq(@fake_user)
            end
            it 'selects the user profile template for rendering' do
                expect(response).to render_template('show')
            end
        end
    end
end