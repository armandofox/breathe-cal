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
* Fork & clone the repo, <a href="https://www.ruby-lang.org/en/documentation/installation/"> install Ruby 2.3.0 </a>, <a href="http://blog.teamtreehouse.com/install-rails-5-mac"> install Rails 4.2.6 </a>, run:
```
  gem install bundler
  bundle install
```
* Set API keys manually in heroku. They are Accuweather, Google SSO, and Google Maps.
* Add your deployment url to the list of Google SSO redirect link on the Breathe California Google API Account.

## Database
### Setup
```
  bundle exec rake db:migrate
  bundle exec rake db:test:prepare
```
  This will run all of our migrations for development and test environments while considering dependencies.
### Clear all markers from heroku database:
```
  heroku run pg:reset DATABASE
  heroku run rake db:migrate
```
  And load the seeds with:
```
  heroku run rake db:seed
```
  Seeds can be found in db/seeds.rb.

## Development/Deployment
* Before pushing to heroku, assets must be precompiled (they also should be after any app/assets/ edits) with 'RAILS_ENV=production rake assets:precompile'

