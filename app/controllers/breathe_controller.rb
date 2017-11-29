require 'date'
class BreatheController < ApplicationController
  def index
    begin
      feed = Feedjira::Feed.fetch_and_parse("http://www.baaqmd.gov/Feeds/AlertRSS.aspx")
      entry = feed.entries[0]
      @welcome_message = feed.title 
      @alert = entry.summary
    rescue
      @welcome_message = "Spare the Air Day Info"
      @alert = "Spare the Air Day info is currently unavailable"
    end
      
    if @text.nil?
      @text = "Recent Searches"
    end
    @user = current_or_guest_user
    @cities = @user.recent_cities
    @cities ||= []

    @text = "Recent Searches"
    Time::DATE_FORMATS[:custom] = lambda { |time| time.strftime("%B #{time.day.ordinalize}, %Y") }
    @dt = (DateTime.now + Rational(-8,24)).to_formatted_s(:custom)
  end
    
end
