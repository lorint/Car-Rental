require './config/environment'
require 'rspec'
require 'pry'
require './spec/seed_data_helper'

RSpec.configure do |config|
  config.before(:each) do
    ActiveRecord::Base.establish_connection YAML.load_file('db/config.yml')["test"]
  end

  config.after(:each) do
    ActiveRecord::Base.connection.close
  end
end
