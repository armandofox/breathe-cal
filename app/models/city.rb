class City < ActiveRecord::Base
  belongs_to :client
  serialize :daily_data, JSON
  
  def self.get_accuweather_key()
    Rails.application.secrets.WEATHER_KEY
  end
  
  def self.get_resonse(resp, url, query)
    return resp
  end
  
  def has_valid_data
    if self.daily_data.nil?
      return false
    end
    val = self.daily_data[:Code]
    if val.nil?
      return true
    end
    return false
  end
      
      
  def update_city_data
    location_key = self.location_key
    puts "Before --- !!!!!!!!"
    puts self.updated_at
    puts Date.today.to_time.beginning_of_day
    puts self.daily_data.nil?
    puts City.get_accuweather_key()
    puts self.location_key
    if self.updated_at <= Date.today.to_time.beginning_of_day or self.has_valid_data
      url = "http://dataservice.accuweather.com/forecasts/v1/daily/5day/#{location_key}"
      query = {apikey: City.get_accuweather_key(), language:"en-us", details: "true"}
      response = City.get_resonse(HTTParty.get(url, query: query), url, query)
      
      self.update_attribute("daily_data" , response)
    end
    puts "Updating city Data!"
    puts self.daily_data
  end
  
  def self.get_loc_key(lat,lng, name)
    puts name, lat, lng
    city = City.find_by(lat: lat, lng: lng)
    if city
      return city.location_key
    end
    url = "http://dataservice.accuweather.com/locations/v1/cities/geoposition/search"
    query = {apikey: City.get_accuweather_key(), q: "#{lat},#{lng}",language:"en-us" }
    response = City.get_resonse(HTTParty.get(url, query: query), url, query)
    location_key = response["Key"]
    City.create(lat: "#{lat}", lng: "#{lng}", location_key: location_key, name: name)
    puts location_key
    return location_key
  end

end
