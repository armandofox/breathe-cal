require 'rails_helper'

RSpec.describe CitiesController, type: :controller do
    
    describe 'flow of one city' do
        before :each do
            @city = City.new(name: "Berkeley", lat: "37.8716", lng: "-122.2727", location_key: "332044")
            @city.save!
            @city2 = City.new(name: "Fort Lauderdale", lat: "26.1224", lng: "-80.1373", location_key: "328168")
            @city2.save!
            @city3 = City.new(name: "")
        end
        
   
        describe '#cached_city_data' do
            it 'should render the correct template' do
                get :cached_city_data, name: @city.name, format: 'js'
                expect(true).to eq(true)
                expect(response).to render_template("cities/city_data.js.erb")
            end
        end 

        describe '#city_data' do
            it 'when the recent searches does not contain the city being searched' do
                get :cached_city_data, name: @city.name, format:'js'
                latlng = {"lng" => @city.lng, "lat" => @city.lat}
                request.session[:cities] = [{"name" => "not Berkeley"}]
                controller.instance_variable_set(:@quality, 'something')
                get :city_data, name: @city.name, geo: latlng,format: 'js'
                expect(response).to render_template('cities/city_data.js.erb')
            end
            
            it 'when the recent searches contains the city being searched' do
                latlng = {"lng" => @city.lng, "lat" => @city.lat}
                request.session[:cities] = [{"name" => "Berkeley"}]
                controller.instance_variable_set(:@quality, 'something')
                get :city_data, name: @city.name, geo: latlng, format: 'js'
                expect(response).to render_template('cities/city_data.js.erb')
            end
            
            
            it 'when a user requests to see the details of a certain city' do
                # 
                db_city = City.find(@city.id)
                # expect to see the details of a city
                expect(db_city.name).to eq(@city.name)
                expect(db_city.lat).to eq(@city.lat)
                expect(db_city.lng).to eq(@city.lng)
                expect(db_city.location_key).to eq(@city.location_key)
            end
            
            it 'when the user searches a city that has not been searched' do 
                geo = {:lat => "29.7604", :lng => "-95.3698"}
                before = City.count
                post :city_data, {:name => "Houston", :geo => geo, :format => "js"}, {:cities => []}
                expect(response).to render_template('cities/city_data.js.erb')
                expect(City.count).to_not eq(before)
                expect(City.count).to eq(before + 1)
            end
            
            it 'when the user searches a city that has been searched before' do
                geo = {lat: "37.8716", lng: "-122.2727"}
                before = City.count
                post :city_data, {:name => "Berkeley", :geo => geo, :format => "js"}, {:cities => []}
                expect(response).to render_template('cities/city_data.js.erb')
                expect(City.count).to eq(before)
            end
            
        end
        
        describe 'favorite_cities' do
            context 'the user is signed in' do
                before :each do
                    @user =  User.new(name: 'Joseph Brodsky', provider: 'google_oauth2', oauth_token: 'some_token', oauth_expires_at: 'July 1 2017', email: "test@xxxx.com", uid: 101)
                    @user.save!
                end 
                
                describe 'the user has added favorites before' do
                    it 'favorites contains this city' do
                        request.session[:user_id] = @user.id
                        request.session[:favorites] = [{"name" => 'Berkeley'}]
                        controller.instance_variable_set(:@quality, 'something')
                        get :favorite_city, name: @city.name, format: 'js'
                        expect(response).to render_template('cities/city_data.js.erb')
                    end
                    
                    it 'favorites do not contain this city' do
                        request.session[:user_id] = @user.id
                        request.session[:favorites] = [{"name" => 'not Berkeley'}]
                        controller.instance_variable_set(:@quality, 'something')
                        get :favorite_city, name: @city.name, format: 'js'
                        expect(response).to render_template('cities/city_data.js.erb')
                    end
                    
                    it 'favorites should contain the city now' do
                        request.session[:favorites] = [{"name" => 'not Berkeley'}]
                        get :display_favorite_cities, format: 'js'
                        expect(response).to render_template('cities/city_data_back.js.erb')
                    end
                end
                
                describe 'the user has not added any favorites yet' do
                    it 'no favorites should be displayed yet' do
                        request.session[:favorites] = nil
                        get :display_favorite_cities, format: 'js'
                        expect(response).to render_template('cities/city_data_back.js.erb')
                    end
                    
                    it 'no favorites yet but signed in' do
                        request.session[:user_id] = @user.id
                        request.session[:favorites] = nil
                        controller.instance_variable_set(:@quality, 'something')
                        get :favorite_city, name: @city.name, format: 'js'
                        expect(response).to render_template('cities/city_data.js.erb')
                    end
                    
                end 
            end
            
            context 'the user is not signed in' do
                it 'he can not add a favorite this way' do
                    request.session[:user_id] = nil
                    get :favorite_city, name: @city.name, format: 'js'
                    expect(response).to render_template('cities/city_data.js.erb')
                end
            end 
        end
        
        describe '#city_data_back' do
            it 'less that 5 cities have been searched for' do
                request.session[:cities] = [{"name" => '1'}]
                get :city_data_back, format: 'js'
                x = 1
                request.session[:cities].each do |city|
                    expect(city["name"]).to eq(x.to_s)
                end
            end
            
            it 'no cities have been searched for yet' do
                get :city_data_back, format: 'js'
            end
        end
        
        describe '#create' do
            it 'when lat and long for first city are passed and format is json' do
                latlng = {"lng" => @city.lng, "lat" => @city.lat}
                post :create, geo: latlng, name: @city.name, format: 'json'
                expect(response).to be_success
            end 
            
            it 'when lat and long for second city are passed and format is json' do
                latlng2 = {"lng" => @city2.lng, "lat" => @city2.lat}
                post :create, geo: latlng2, name: @city2.name, format: 'json'
                expect(response).to be_success
            end 
            
            it 'when lat and long for first city are passed and format is html' do
                latlng = {"lng" => @city.lng, "lat" => @city.lat}
                post :create, geo: latlng, name: @city.name, format: 'html'
                expect(response).to redirect_to(city_path(id: @city.id))
            end
            
            it 'when lat and long for second city are passed and format is html' do
                latlng = {"lng" => @city2.lng, "lat" => @city2.lat}
                post :create, geo: latlng, name: @city2.name, format: 'html'
                expect(response).to redirect_to(city_path(id: @city2.id))
            end
        end
        
        describe '#show' do
            it 'when the data is being passed properly' do
                @city.daily_data= {"DailyForecasts" => [{"AirAndPollen" => 'fine'}, {"AirAndPollen" => 'fine'}, {"AirAndPollen" => 'fine'}, {"AirAndPollen" => 'fine'}, {"AirAndPollen" => 'fine'}]}
                @city.save!
                @city.update_attribute("daily_data", {"DailyForecasts" => [{"AirAndPollen" => 'fine'}, {"AirAndPollen" => 'fine'}, {"AirAndPollen" => 'fine'}, {"AirAndPollen" => 'fine'}, {"AirAndPollen" => 'fine'}]})
                get :show, id: @city.id
            end
        end
        
    end
    
    # Pivotal Tracker ID#152020968
    describe 'client_searches feature' do
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
            @user = User.create_user_from_omniauth(@user_hash)
            allow(@user).to receive(:id).and_return(101)
            
            @berk_geo = {:lat => "37.8716", :lng => "-122.2727"}
            @hous_geo = {:lat => "29.7604", :lng => "-95.3698"}
            @fld_geo = {:lat => "26.1224", :lng => "-80.1373"}
            @mia_geo = {:lat => "25.7617", :lng => "-80.1918"}
            @aus_geo = {:lat =>"30.2672", :lng => "-97.7431"}
            @sfo_geo = {:lat => "37.7749", :lng => "-122.4194"}
            
            @city = City.new(name: "Berkeley", lat: "37.8716", lng: "-122.2727", location_key: "332044")
            @city.save!
            @city2 = City.new(name: "Fort Lauderdale", lat: "26.1224", lng: "-80.1373", location_key: "328168")
            @city2.save!
            session[:user_id] = 101
        end
        
        it 'recent_cities of a user should be changed after a search to a city' do
            geo = @fld_geo
            expect(@user.recent_cities.size).to eq(0)
            post :city_data, :geo => geo, :name => "Fort Lauderdale", :format => "js"
            expect(assigns(:cities).size).to eq(1)
        end
    

       

        
        it 'user recent cities should change after a search to a city' do
            geo = @fld_geo
            expect(@user.recent_cities.size).to eq(0)
            post :city_data, :geo => geo, :name => "Fort Lauderdale", :format => "js"
            expect(assigns(:cities).size).to eq(1)
            geo = @berk_geo
            post :city_data, :geo => geo, :name => "Berkeley", :format => "js"
            expect(assigns(:cities).size).to eq(2)
            geo = @hous_geo
            post :city_data, :geo => geo, :name => "Houston", :format => "js"
            expect(assigns(:cities).size).to eq(3)
        end
        
        
        it 'user recent cities does not change when user queries same location' do
            geo = @fld_geo
            expect(@user.recent_cities.size).to eq(0)
            post :city_data, :geo => geo, :name => "Fort Lauderdale", :format => "js"
            expect(assigns(:cities).size).to eq(1)
            geo = @berk_geo
            post :city_data, :geo => geo, :name => "Berkeley", :format => "js"
            expect(assigns(:cities).size).to eq(2)
            geo = @fld_geo
            post :city_data, :geo => geo, :name => "Fort Lauderdale", :format => "js"
            expect(assigns(:cities).size).to eq(2)
            geo = @berk_geo
            post :city_data, :geo => geo, :name => "berkeley", :format => "js"
            expect(assigns(:cities).size).to eq(2)
        end
        

        it 'user recent cities should have at most five cities at all time' do
            geo = @fld_geo
            expect(@user.recent_cities.size).to eq(0)
            post :city_data, :geo => geo, :name => "Fort Lauderdale", :format => "js"
            geo = @berk_geo
            post :city_data, :geo => geo, :name => "Berkeley", :format => "js"
            geo = @hous_geo
            post :city_data, :geo => geo, :name => "Houston", :format => "js"
            geo = @mia_geo
            post :city_data, :geo => geo, :name => "Miami", :format => "js"
            geo = @aus_geo
            post :city_data, :geo => geo, :name => "Austin", :format => "js"
            geo = @sfo_geo
            post :city_data, :geo => geo, :name => "San Francisco", :format => "js"
            expect(assigns(:cities).size).to eq(5)
        end 
    end
end
