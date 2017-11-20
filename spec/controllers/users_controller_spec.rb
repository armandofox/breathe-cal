require 'rails_helper'

RSpec.describe UsersController, type: :controller do
    
    before :each do
            session[:user_id] = 1
    end
    
    describe ' filters' do
        it 'calls the function to check to see if user is logged in' do
            expect(controller).to receive(:require_login)
            get :show, {:id => 1}
        end
        it 'sends non logged in users to homepage' do
            session[:user_id] = nil
            expect(response).to render_template('/')
            get :show, {:id => 1}
        end
    end
    
    describe ' #show' do
        before :each do
            @fake_user = double('user')
        end
        describe ' with invalid credentials' do
            after :each do
                get :show, {:id => 2}
            end
            it 'sends a flash message indicating invalid credentials' do
                expect(flash[:profile]).to eq("Cannot View Profile: Not Signed In")
            end
            it 'redirects user to the homepage' do
                expect(response).to render_template('/')
            end
        end
        
        describe ' with valid credentials' do
            it 'finds the user '
            it 'feeds user data to the view'
            it 'selects the user profile template for rendering' do
                expect(assigns(:user)).to eq(@fake_user)
            end
        end
    end
end