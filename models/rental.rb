class Rental < ActiveRecord::Base
  # foreign_key is not needed here just because the names of the belongs_to fields
  # are EXACTLY the same as the foreign key names.

  # The customer
  belongs_to :customer, class_name: "User", inverse_of: :rented_cars

  # The driver
  belongs_to :primary_driver, class_name: "User", inverse_of: :driven_cars

  # The employee who gives out the car
  belongs_to :clerk, class_name: "User", inverse_of: :given_cars, required: false

  # The employee with whom they drop back off
  belongs_to :collector, class_name: "User", inverse_of: :collected_cars, required: false

  belongs_to :vehicle

  before_save :ensure_user_is_customer, :primary_driver_defaults_to_customer
  before_update :set_actual_drop_off_time_when_returning

  validate :ensure_no_time_collision
  validate :ensure_no_collector_on_create,
           :ensure_not_renting_to_themselves,
           :ensure_clerk_has_proper_role,
           :ensure_no_drop_off_time_on_create, on: :create

  validate :ensure_has_odometer_when_returning,
           :ensure_has_fuel_level_when_returning,
           :ensure_not_collected_by_themselves_when_returning, on: :update

  def days
    seconds = (actual_drop_off_time || drop_off_time) - pick_up_time
    # Subtract one second just in case there are rounding errors not in favor of the customer
    # 86400 seconds in a day
    ((seconds - 1.0) / 86400.00).ceil
  end

  private

  # CREATE validators
  def ensure_no_time_collision
    unless self.vehicle.is_available(self.pick_up_time, self.drop_off_time, self)
      self.errors.add(:pick_up_time, "That timeframe collides with another rental!")
    end
  end

  def ensure_no_collector_on_create
    if self.collector
      self.errors.add(:collector, "Collector should not yet be set for new rentals!")
    end
  end

  def ensure_not_renting_to_themselves
    if self.customer == self.clerk
      self.errors.add(:customer, "Clerk can not be the same as the customer!")
    end
  end

  def ensure_clerk_has_proper_role
    unless self.clerk.is_a "Clerk"
      self.errors.add(:clerk, "#{self.clerk.nil? ? "(nil)" : self.clerk.name } is not a clerk!")
    end
  end

  def ensure_no_drop_off_time_on_create
    if self.actual_drop_off_time
      self.errors.add(:actual_drop_off_time, "Actual drop off time should not yet be set for new rentals!")
    end
  end

  # UPDATE validators
  def ensure_has_odometer_when_returning
    if self.changed.include?("collector_id") && !self.collector_id.nil? &&
        self.odometer.nil?
      self.errors.add(:odometer, "Must record odometer reading when returning a vehicle!")
    end
  end

  def ensure_has_fuel_level_when_returning
    if self.changed.include?("collector_id") && !self.collector_id.nil? &&
        self.fuel_level.nil?
      self.errors.add(:fuel_level, "Must record fuel level when returning a vehicle!")
    end
  end

  def ensure_not_collected_by_themselves_when_returning
    if self.changed.include?("collector_id") && !self.collector_id.nil? &&
        self.collector == self.customer
      self.errors.add(:collector, "Can not be collected by themselves!")
    end
  end

  # Hooks
  def ensure_user_is_customer
    cust = Role.find_by(name: "Customer")
    self.customer.roles << cust unless self.customer.is_a cust
  end

  def primary_driver_defaults_to_customer
    self.primary_driver ||= self.customer
  end

  def set_actual_drop_off_time_when_returning
    if self.changed.include?("collector_id") && !self.collector_id.nil?
      self.actual_drop_off_time ||= Time.now
      self.drop_off_time ||= self.actual_drop_off_time
    end
  end
end
