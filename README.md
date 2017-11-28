# Breathe California Allergen Map
<img src="https://api.codeclimate.com/v1/badges/836757131179145c6ddf/maintainability" />
<img src="https://travis-ci.org/MaadhavShah/breathe-cal.svg?branch=master" alt="Build Status" />
<img src="https://api.codeclimate.com/v1/badges/836757131179145c6ddf/test_coverage" />

### Pivotal Link

https://www.pivotaltracker.com/n/projects/2118203

### Heroku Link (Master Branch)

https://breathe-cal.herokuapp.com/

### Client Site

http://www.breathebayarea.org/

Our overall goal is to provide information on airborne allergens and air quality to those who need it.

## Genral Setup

Fork/clone the repo, then run bundle install. The gemfile with dependencies is included in the repository so bundler should locate and use it.

API Keys - set manually in heroku. They include Accuweather, Google SSO, and Google Maps.

Make sure to add your deployment url to the list of Google SSO redirect links, do so here:




  
## Database

Setup - run 'bundle exec rake db:migrate', then 'bundle exec rake db:test:preapare'. This will run all of our migrations for development and test environments while considering dependencies.

Clear all markers from heroku database - 'heroku run pg:reset DATABASE' will clear, then 'heroku run rake db:migrate' will run our migrations and 'heroku run rake db:seed' will populate the database with any seeds. Seeds can be found in F>SDJFLDSJFS



###Development/Deployment

Before pushing to heroku, assets must be precompiled (they also should be after any app/assets/ edits) with 'RAILS_ENV=production rake assets:precompile'

