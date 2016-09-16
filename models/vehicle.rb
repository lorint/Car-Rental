class Vehicle < ActiveRecord::Base
  has_many :rentals

  # Joe's cool algorithm to identify scheduling collisions
  def is_available(pu_time = Time.now, dr_time = nil, not_counting_rental = nil)
    dr_time = pu_time if dr_time.nil?
    self.reload
    result = true
    self.rentals.each do |rental|
      next if rental == not_counting_rental
      # Get either the actual drop off time, or if it's nil
      # then the anticipated drop off time.
      # (If we have an actual_drop_off_time anyway)
      dropoff_time = rental.actual_drop_off_time
      dropoff_time ||= rental.drop_off_time if !rental.drop_off_time.nil? && Time.now < rental.drop_off_time

      if (dr_time > rental.pick_up_time &&
          (dropoff_time.nil? || dropoff_time > pu_time))
        result = false
      end
    end
    result
  end
end
