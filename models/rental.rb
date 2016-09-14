class Rental < ActiveRecord::Base
  # foreign_key is not needed here just because the names of the belongs_to fields
  # are EXACTLY the same as the foreign key names.

  # The customer
  belongs_to :customer, class_name: "User", inverse_of: :rented_cars

  # The employee who gives out the car
  belongs_to :clerk, class_name: "User", inverse_of: :given_cars

  # The employee with whom they drop back off
  belongs_to :collector, class_name: "User", inverse_of: :taken_cars
end
