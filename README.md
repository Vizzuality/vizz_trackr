# Vizz Tracker [![Build Status](https://travis-ci.com/Vizzuality/vizz_trackr.svg?branch=master)](https://travis-ci.com/Vizzuality/vizz_trackr)

## Dependencies

- Ruby 2.7.6
- Rails 6.1
- PostgreSQL 10.x
- Node 18.11

## Setting up your local environment

- `git clone git@github.com:Vizzuality/vizz_trackr.git`
- `cd vizz_trackr`
- `bundle install`
- `yarn install`
- `bundle exec rails db:create`
- `bundle exec rails db:migrate`

## Starting the project

- `bundle exec rails server`
- point your browser to `http://localhost:3000`

## Setting up .env file

Before upping your Rails server, you should also create a `.env` file with the necessary env variables. These are stated in the `.env.sample` file, so you only need to copy the file and fill the variables appropriately.

## Development

To properly work on the application in your local environment you'll need to add
some data to your database. You can start simple and just create a user, add
fake data to have a better dataset, or get a database dump from one of the live
versions and import it.

### Getting a User setup and more data

You will need to create a user to be able to login and add data to the tool.
You will need to do that via the console, as registration of new users via the interface
is currently disabled, to do so, type this into your terminal:

`rails console`
`User.create(email: "youremail@yourorg.yourdomain", password: "your_password", password_confirmation: "your_password", admin: true, name: "Your Name")`

After this you'll be able to login with those details!

### Using Seeds

There area series of seeds on `db/seeds.rb` that are generated using the
[Faker gem](https://github.com/faker-ruby/faker). You can import those with
`bundle exec rails db:seed`.

### Getting a dump from staging or production

Both staging and production versions of the application are deployed on Heroku
so if you want to work with a closer to real version of the data you can
create a backup from Heroku and download the database dump to import to your
development database. [Read more about it here](https://devcenter.heroku.com/articles/heroku-postgres-backups).


## Tests and Style checks

### Tests

- Update your test database if needed `bundle exec rails db:test:prepare`
- Run them: `bundle exec rails test`

### Style checks

- Run rubocop: `bundle exec rubocop`
