require './config/environment'
require './spec/seed_data_helper'

extend SeedData

ActiveRecord::Base.connection.close
