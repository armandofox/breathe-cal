# Breathe California Allergen Map
<img src="http://travis-ci.org/MaadhavShah/breathe-cal.svg?branch=master" alt="Build Status" /> <a href="https://codeclimate.com/github/MaadhavShah/breathe-cal/maintainability"><img src="https://api.codeclimate.com/v1/badges/836757131179145c6ddf/maintainability" /></a> 
<a href="https://codeclimate.com/github/MaadhavShah/breathe-cal/test_coverage"><img src="https://api.codeclimate.com/v1/badges/836757131179145c6ddf/test_coverage" /></a>

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
* Fork & clone the repo, install <a href="https://www.ruby-lang.org/en/documentation/installation/"> Ruby 2.3.0 </a>, install <a href="http://blog.teamtreehouse.com/install-rails-5-mac"> Rails 4.2.6 </a>, run:
```
  gem install bundler
  bundle install
```
* Set API keys manually in heroku. They are Accuweather, Google OAuth 2.0, and Google Maps.
* Add your deployment url to the list of Google SSO redirect link on the Breathe California Google API Account.

## Database
#### Setup
```
  bundle exec rake db:migrate
  bundle exec rake db:test:prepare
  heroku run rake db:migrate
```
  This will run all of our migrations for development, test, and production environments while considering dependencies.
#### Clear all markers from heroku database:
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
* Setup <a href="https://devcenter.heroku.com/articles/getting-started-with-ruby#introduction"> Heroku </a>
* Before pushing to heroku, assets must be precompiled (they also should be after any app/assets/ edits):
```
  RAILS_ENV=production rake assets:precompile
```
#### Push to Heroku (only the heroku remote's master branch deploys)
```
  git push heroku master
```
## Testing
#### Spec Tests
```
  bundle exec rspec
```
#### Cucumber Feature Files
```
  bundle exec cucumber
```
