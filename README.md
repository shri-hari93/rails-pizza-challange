# rails-pizza-challange

## Setup
### Pre-requsite
- Rails 6, Ruby 3.0.4, Postgres 7+
### Steps
- Clone the repository
- In the root directory ```bundle install``` 
- Create database using ```rake db:create```
- Run migration to create necessary tables ```rake db:migrate```
- Run rake task ```rake sample_data:create``` to create sample data for index page 
- Start the server using ```rails s``` command