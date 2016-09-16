require './spec/spec_helper'

# These all CREATE the Rental
describe Rental do
  before do
    extend SeedData
    @valid_rental = @homer.rented_cars.new(vehicle: @family_sedan, clerk: @lou, pick_up_time: Time.now, drop_off_time: Time.now + 2.days)
  end
  context "as a clerk" do
    context "with valid rental information" do   # HAPPY PATH
      it "should be able to rent out a car to a customer" do
        expect(@valid_rental).to be_valid
      end
      it "should have a related customer and clerk" do
        expect(@valid_rental.customer).to_not be_nil
        expect(@valid_rental.clerk).to_not be_nil
      end
      it "should be able to act as a customer to rent out a car from another clerk" do
        # Make Marge a clerk
        @marge.roles << @clerk
        # Lou should be able to rent a car from Marge
        new_rental = @lou.rented_cars.new(vehicle: @lil_bandit, clerk: @marge, pick_up_time: Time.now)
        expect(new_rental).to be_valid
      end
      it "should be able to rent out a car in the future, anticipating it will be returned" do
        @homer.roles << @clerk
        new_rental = @lou.rented_cars.new(vehicle: @family_sedan, clerk: @homer, pick_up_time: Time.now + 2.days + 4.hours, drop_off_time: Time.now + 4.days)
        expect(new_rental).to be_valid
      end
      it "should have the primary driver default to the customer renting the car" do
        @valid_rental.save
        expect(@valid_rental.primary_driver).to eq(@homer)
      end
      it "should be able to rent out an additional car " +
        "if the primary driver is different than for other vehicles " +
        "being rented during the same timeframe" do
        @valid_rental.primary_driver = @marge
        @valid_rental.save
        # Primary driver of this additional vehicle will default to being Homer
        new_rental = @homer.rented_cars.new(vehicle: @lil_bandit, clerk: @lou, pick_up_time: Time.now)
        expect(@valid_rental).to be_valid
        expect(new_rental).to be_valid
      end
      it "should cause that the renting individual becomes a customer if they were not previously" do
        @valid_rental.save
        expect(@homer.is_a "Customer").to be_truthy
      end
    end

    context "with invalid rental information" do   # SAD PATH
      it "should only be rented out by someone who is a clerk" do
        @valid_rental.clerk = @eddie
        expect(@valid_rental).to_not be_valid
      end
      it "should not be valid for creation with a collector" do
        @valid_rental.collector = @eddie
        expect(@valid_rental).to_not be_valid
      end
      it "should not be valid for creation with an actual drop-off time" do
        @valid_rental.actual_drop_off_time = @valid_rental.drop_off_time
        expect(@valid_rental).to_not be_valid
      end
      it "should not be able to rent out a car that is already rented out" do
        @valid_rental.save
        @homer.roles << @clerk
        # Try an overlap that starts before the valid one, and ends in the middle
        new_rental = @lou.rented_cars.new(vehicle: @family_sedan, clerk: @homer, pick_up_time: Time.now - 1.day, drop_off_time: Time.now + 1.days)
        expect(new_rental).to_not be_valid
        # Try an overlap that starts in the middle of the valid one, and ends a day after
        new_rental = @lou.rented_cars.new(vehicle: @family_sedan, clerk: @homer, pick_up_time: Time.now + 1.day, drop_off_time: Time.now + 3.days)
        expect(new_rental).to_not be_valid
        # Try an overlap that starts before the valid one, and ends a day after
        new_rental = @lou.rented_cars.new(vehicle: @family_sedan, clerk: @homer, pick_up_time: Time.now - 1.day, drop_off_time: Time.now + 3.days)
        expect(new_rental).to_not be_valid
      end
      it "should not be able to rent out an additional car " +
        "if the primary driver is the same as for another vehicle " +
        "during the same timeframe" do
        @valid_rental.primary_driver = @homer
      end
      it "should not be able to rent out a car to themselves" do
        @valid_rental.customer = @lou
        expect(@valid_rental).to_not be_valid
      end
    end
  end

  # These all UPDATE the Rental
  context "as a collector" do
    before do
      @valid_rental.save
    end
    context "with a valid rental" do   # HAPPY PATH
      it "should be able to mark a car as returned, having an actual drop off time" do
        @valid_rental.update(collector: @eddie, odometer: 20000, fuel_level: 8)
        expect(@valid_rental).to be_valid
        expect(@valid_rental.actual_drop_off_time).to_not be_nil
      end
    end
    context "with invalid return information" do   # SAD PATH
      it "should not be able to return a car if the odometer reading is absent" do
        @valid_rental.update(collector: @eddie, fuel_level: 8)
        expect(@valid_rental).to_not be_valid
      end
      it "should not be able to return a car if the fuel level is absent" do
        @valid_rental.update(collector: @eddie, odometer: 20000)
        expect(@valid_rental).to_not be_valid
      end
      it "should not be able to accept a car that was rented out by themselves" do
        @homer.roles << @collector
        @valid_rental.update(collector: @homer, odometer: 20000, fuel_level: 8)
        expect(@valid_rental).to_not be_valid
      end
    end
  end
end
