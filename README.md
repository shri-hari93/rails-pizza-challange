# rails-pizza-challange

## Setup
### Pre-requsite
- Rails 6, Ruby 3.0.4, Postgres 7+
### Steps
- Clone the repository
- In the root directory ```bundle install```
- Create postgres user/password and update accordingly in ```config/database.yml```
- Setup your database with necessary tables and data using ```rake db:setup```
- Install webpacker using ```rake webpacker:install```
- Start the server using ```rails s``` command