require 'rails_helper'

RSpec.describe City, type: :model do
  before :each do
    @city = City.new(name: "Berkeley", lat: "37.8716", lng: "-122.2727", location_key: "332044")
    @city.save!
    
    @city2 = City.new(name: "Houston", lat: "29.7604", lng: "-95.3698")
    @city2.save!
  end
  
  describe "city#get_location_key" do
  
    it "gets the location key" do 
      # byebug
      expect(City.get_loc_key("37.8716", "-122.2727", "Berkeley")).to eq("332044")
    end
    
    it "gets the location key " do
      expect(City.get_loc_key(@city2.lat, @city2.lng, @city2.name)).to eq("351197")
    end
  end
  
  describe "city#update_daily_data" do
    it "updates the daily_data" do
      expect(@city.daily_data).to eq(nil)
      @city.update_city_data
      expect(@city.daily_data).to have_key("DailyForecasts")
    end
  end

end
