require './config/environment'
require './spec/seed_data_helper'
require 'pry'

extend SeedData

ActiveRecord::Base.connection.close
