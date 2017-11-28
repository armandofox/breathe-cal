# Breathe California Allergen Map
<img src="https://api.codeclimate.com/v1/badges/836757131179145c6ddf/maintainability" /> <img src="https://travis-ci.org/MaadhavShah/breathe-cal.svg?branch=master" alt="Build Status" /> <img src="https://api.codeclimate.com/v1/badges/836757131179145c6ddf/test_coverage" />
## Goal
Our overall goal is to provide information on airborne allergens and air quality to those who need it.

## Links
#### Pivotal Tracker Link
https://www.pivotaltracker.com/n/projects/2118203

#### Heroku Deployment Link (Master Branch)
https://breathe-cal.herokuapp.com/

#### Breathe California's Website
http://www.breathebayarea.org/

## Genral Setup
* Fork & clone the repo, <a href="http://blog.teamtreehouse.com/install-rails-5-mac"> install Rails</a>, run 
...
'gem install bundler' then 'bundle install'
...
* API Keys - set manually in heroku. They include Accuweather, Google SSO, and Google Maps.
* Add your deployment url to the list of Google SSO redirect link on the Breathe California Google API Account.
  
## Database
* Setup - run 'bundle exec rake db:migrate', then 'bundle exec rake db:test:preapare'. This will run all of our migrations for development and test environments while considering dependencies.
* Clear all markers from heroku database - 'heroku run pg:reset DATABASE' will clear, then 'heroku run rake db:migrate' will run our migrations and 'heroku run rake db:seed' will populate the database with any seeds. Seeds can be found in db/seeds.rb.

## Development/Deployment
* Before pushing to heroku, assets must be precompiled (they also should be after any app/assets/ edits) with 'RAILS_ENV=production rake assets:precompile'

