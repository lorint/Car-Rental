class AddStuffToRentals < ActiveRecord::Migration
  def change
    add_column :rentals, :actual_drop_off_time, :datetime
    add_column :rentals, :odometer, :integer
    add_column :rentals, :fuel_level, :integer
    add_reference :rentals, :primary_driver, index: true  #, foreign_key: true
  end
end
