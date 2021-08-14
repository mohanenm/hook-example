# README

creates a webhook endpoint to receive posts, uses REDIS and SIDEKIQ to process them in the background and relay that information to subscribers!

add your own database.yml

then, after normal start tasks(bundle install, setup), run `brew services start redis` then `bundle exec sidekiq`
