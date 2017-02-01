# Currency display

[![Build Status](https://travis-ci.org/epsylonix/currency\_display.svg?branch=master)](https://travis-ci.org/epsylonix/currency\_display)

Home: https://github.com/epsylonix/currency_display

Bugs: https://github.com/epsylonix/currency_display/issues

#Description
This is a simple Rails app that does the following:

* displays the exchange rate for selected currencies at the site's root.
By default there is only one currency (USD) that uses CBR.ru as the source for the exchange rate.
* at '/admin' there is an interface to manually set (force) exchange rate for the selected currency. When the forced exchange rate is set, it is displayed at the site's root instead of the actual value untill the specified time. *Note*: admin interface doesn't require any authentication (this is a sample app).


## Requirements

This app is made for educational purposes so it was only tested in a handful of browsers, though it would probably work fine in all modern browsers:

| Browsers |
| -------- |
| Google Chrome 23+ |
| Firefox 16+ |


## Built With

- [Ruby on Rails 5](https://github.com/rails/rails) &mdash; Back end is a Rails app.
- [SQLite](https://www.sqlite.org/) &mdash; This is not a production ready app so for simplicity sake SQLite is used. It is easily swaped with a DB of your choice, seeds.rb file is provided.
- [Redis](http://redis.io/) &mdash; The app is using Rails' ActionCable which relies on Redis.

A complete list required Ruby Gems is at [/master/Gemfile](https://github.com/epsylonix/currency\_display/blob/master/Gemfile).


## Installation

	git clone https://github.com/epsylonix/currency_display.git
	cd currency_display
	bundle install

## Database initialization

	bin/rails db:migrate db:seed

## Running the app

Note: Redis server is expected to be running at port 6379. Otherwise please change the setting in /config/cable.yml.

	foreman start

foreman will start these processes:
- delayed job worker (performs background jobs)
- clockwork (jobs schedulling)

Open a browser.
* index is at http://localhost:3000/
* admin is at http://localhost:3000/admin

## Running tests

Make sure PhantomJS and all gems from :test group are installed.
	
	bin/rails db:migrate RAILS_ENV=test
	bin/rails test

