require 'standalone_migrations'

# require './models/user'
# require './models/role'
# require './models/user_role'
# require './models/rental'

# Nice automatic way to require all models
# Courtesy of our guy Finn
Dir[File.expand_path("../models/*.rb", __dir__)].each { |file| require file }

ActiveRecord::Base.establish_connection(
  YAML.load_file('db/config.yml')[ENV["RAILS_ENV"] || ENV["RACK_ENV"] || "development"]
)
