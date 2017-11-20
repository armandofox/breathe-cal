require 'rails_helper'

RSpec.describe UsersController, type: :controller do
    
    before :each do
            
    end
    
    describe '#show' do
        it 'should check to see if a user is logged in' do
            
        end
        it 'calls the application controller method that finds the current user'
        it 'feeds user data to the view'
        describe '#cached_city_data' do
            it 'should render the correct template' do
                get :cached_city_data, name: @city.name, format: 'js'
                expect(response).to render_template("cities/city_data.js.erb")
            end
        end 
    end
end