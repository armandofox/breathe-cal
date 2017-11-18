class City < ActiveRecord::Base
  belongs_to :user
  validates :name, :lat, :lng, presence: true
  serialize :daily_data, JSON
  
  def self.get_accuweather_key()
    Rails.application.secrets.WEATHER_KEY
  end
  
  def self.get_resonse(resp, _url, _query)
    # JS: I found args url and query unused so added in _ to improve test coverage
    return resp
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
    location_key = self.location_key
    puts location_key
    if self.updated_at.nil? or self.updated_at <= Date.today.to_time.beginning_of_day or !has_valid_data()
      url = "http://dataservice.accuweather.com/forecasts/v1/daily/5day/#{self.location_key}"
      query = {apikey: City.get_accuweather_key(), language:"en-us", details: "true"}
      response = City.get_resonse(HTTParty.get(url, query: query), url, query)
      self.update_attribute("daily_data" , response)
    end
  end
  
  def self.obtain_loc_key(lat, lng)
    # We want to avoid creating a City object when we get location key
    url = "http://dataservice.accuweather.com/locations/v1/cities/geoposition/search"
    query = {apikey: City.get_accuweather_key(), q: "#{lat},#{lng}",language:"en-us" }
    response = City.get_resonse(HTTParty.get(url, query: query), url, query)
    return response["Key"]
  end
  
  def self.get_loc_key(lat,lng, name)
    city = City.find_by(lat: lat, lng: lng)
    if city and !city.location_key.nil?
      return city.location_key
    end
    url = "http://dataservice.accuweather.com/locations/v1/cities/geoposition/search"
    query = {apikey: City.get_accuweather_key(), q: "#{lat},#{lng}",language:"en-us" }
    response = City.get_resonse(HTTParty.get(url, query: query), url, query)
    location_key = response["Key"]
    City.create(lat: "#{lat}", lng: "#{lng}", location_key: location_key, name: name)
    return location_key
  end

end
