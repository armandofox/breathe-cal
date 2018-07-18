class City < ActiveRecord::Base
  belongs_to :user
  validates :name, :lat, :lng, presence: true
  serialize :daily_data, JSON
  
  def self.get_accuweather_key()
    Rails.application.secrets.WEATHER_KEY
  end
  
  def has_valid_data
    if self.daily_data.nil?
      return false
    end
    val = self.daily_data.key?("Code")
    if !val
      return true
    end
    return false
  end
      
  def update_city_data
    if self.updated_at.nil? or self.updated_at <= Date.today.to_time.beginning_of_day or !has_valid_data()
      url = "http://dataservice.accuweather.com/forecasts/v1/daily/5day/#{self.location_key}"
      query = {apikey: City.get_accuweather_key(), language:"en-us", details: "true"}
      resp = HTTParty.get(url, query: query)
      self.update_attribute("daily_data" , resp)
    end
  end
  
  def self.obtain_loc_key(lat, lng)
    # We want to avoid creating a City object when we get location key
    url = "http://dataservice.accuweather.com/locations/v1/cities/geoposition/search"
    query = {apikey: City.get_accuweather_key(), q: "#{lat},#{lng}",language:"en-us" }
    resp = HTTParty.get(url, query: query)
    return resp["Key"]
  end
  
  def self.get_loc_key(lat,lng, name)
    city = City.find_by(lat: lat, lng: lng)
    if city and !city.location_key.nil?
      return city.location_key
    end
    url = "http://dataservice.accuweather.com/locations/v1/cities/geoposition/search"
    query = {apikey: City.get_accuweather_key(), q: "#{lat},#{lng}",language:"en-us" }
    resp = HTTParty.get(url, query: query)
    location_key = resp["Key"]
    City.create(lat: "#{lat}", lng: "#{lng}", location_key: location_key, name: name)
    return location_key
  end
  
  # Helper function to get city, ensure city in database
  def self.obtain_stored_city(lat, lng, place_name)
    city = City.find_by(:lat => lat, :lng => lng)
    if city.nil?
      location_key = City.obtain_loc_key(lat, lng)
      city = City.create!(:lat => lat, :lng => lng, :name => place_name, :location_key => location_key)
    end
    city.update_city_data
    return city
  end

end
