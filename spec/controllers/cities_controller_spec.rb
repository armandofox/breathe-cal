require 'rails_helper'

RSpec.describe CitiesController, type: :controller do
    
    describe 'flow of one city' do
        before :each do
            @city = City.new(name: "Berkeley", lat: "37.8716", lng: "-122.2727", location_key: "332044")
            @city.save!
            @city2 = City.new(name: "Fort Lauderdale", lat: "26.1224", lng: "-80.1373", location_key: "328168")
            @city2.save!
        end
   
        describe '#cached_city_data' do
            it 'should render the correct template' do
                get :cached_city_data, name: @city.name, format: 'js'
                expect(true).to eq(true)
                expect(response).to render_template("cities/city_data.js.erb")
            end
        end 
        
        describe '#map_search' do
            it 'when a user searches for a city' do
               # attempt to query city
               # post map_search 
               lat = "37.8716"
               lng = "-122.2727"

               
               post :map_search, {:geo => {:lat => lat, :lng => lng}}
               expect(response.status).to eq(200)
               
               new_lat = "32.2332"
               new_lng = "-42.3231"
               post :map_search, {:geo => {:lat => new_lat, :lng => new_lng}}
               expect(response.status).to eq(201)
               
               new_lat = "32.2332"
               new_lng = "-42.3231"
               post :map_search, {:geo =>{:lat => new_lat, :lng => new_lng}}
               expect(response.status).to eq(200)
               expect(true).to eq(true)
            end
            
            it 'when a user searches for a city, he/she has searched before' do
               lat = "37.8716"
               lng = "-122.2727"
               post :map_search, {:geo =>{:lat => lat, :lng => lng}}
               expect(response.status).to eq(200)
            #   expect(response).to render_template("cities/city_data.js.erb")
               # ensure City object is valid, find by geo location
                # valid_data
                # get city_data {city_id}
                # expect successful response
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
            
            it 'when the recent searches does contain the city being searched' do
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
                puts db_city.name
                puts @city.name
                puts db_city.lat
                puts @city.lat
                puts db_city.lng
                puts @city.lng
                puts db_city.location_key
                puts @city.location_key
                expect(db_city.name).to eq(@city.name)
                expect(db_city.lat).to eq(@city.lat)
                expect(db_city.lng).to eq(@city.lng)
                expect(db_city.location_key).to eq(@city.location_key)
            end
            
            it 'when the user searches a city that has not been searched' do 
                geo = {:lat => "29.7604", :lng => "-95.3698"}
                before = City.count
                puts before
                post :city_data, {:name => "Houston", :geo => geo, :format => "js"}, {:cities => []}
                expect(response).to render_template('cities/city_data.js.erb')
                puts City.count
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
            it 'more than 5 cities have been searched for' do
                request.session[:cities] = [{"name" => '1'}, {"name" => '2'}, {"name" => '3'}, {"name" => '4'}, {"name" => '5'}, {"name" => '6'}]
                get :city_data_back, format: 'js'
                x = 2
                request.session[:cities].each do |city|
                   expect(city["name"]).to eq(x.to_s) 
                   x = x + 1
                end
            end
            
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
    
end
