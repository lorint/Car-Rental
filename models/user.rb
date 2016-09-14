class User < ActiveRecord::Base
  has_many :user_roles
  has_many :roles, through: :user_roles

  # From the perspective of being a customer
  has_many :rented_cars, class_name: "Rental", foreign_key: :customer_id, inverse_of: :customer

  # From the perspective of employee who gives out the car
  has_many :given_cars, class_name: "Rental", foreign_key: :clerk_id, inverse_of: :clerk

  # From the perspective of employee with whom they drop back off
  has_many :taken_cars, class_name: "Rental", foreign_key: :collector_id, inverse_of: :collector

  def is_a(role_name)
    role = Role.find_by(name: role_name)
    self.user_roles.map(&:role_id).include? role.id
  end
end
