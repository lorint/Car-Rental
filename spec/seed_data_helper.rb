module SeedData
  # When this module is extended into a class or test...
  def self.extended(object)
    # ... make instance variables available.
    object.instance_exec do

      UserRole.destroy_all
      User.destroy_all
      Role.destroy_all

      # Users
      @burns=User.create(name: "Charles Montgomery Burns")
      @roger_meyers=User.create(name: "Roger Meyers, Jr.")
      @krusty=User.create(name: "Krusty the Clown")
      @sideshow_bob=User.create(name: "Sideshow Bob")
      @sideshow_mel=User.create(name: "Sideshow Mel")
      @mr_teeny=User.create(name: "Mr. Teeny")
      @radioactive_man=User.create(name: "Radioactive Man")
      @bailey=User.create(name: "Mary Bailey")
      @smithers=User.create(name: "Waylon Smithers")
      @fat_tony=User.create(name: "Fat Tony")
      @quimby=User.create(name: "Mayor \"Diamond Joe\" Quimby")
      @wiggum=User.create(name: "Chief Clancy Wiggum")
      @lou=User.create(name: "Lou")
      @eddie=User.create(name: "Eddie")
      @lovejoy=User.create(name: "Reverend Timothy Lovejoy")
      @helen=User.create(name: "Helen Lovejoy")
      @carl=User.create(name: "Carl Carlson")
      @lenny=User.create(name: "Lenny Leonard")
      @marge=User.create(name: "Marge Simpson")
      @homer=User.create(name: "Homer Simpson")
      @bart=User.create(name: "Bart Simpson")
      @lisa=User.create(name: "Lisa Simpson")

      # Roles
      @customer = Role.create(name: "Customer")
      @clerk = Role.create(name: "Clerk")
      @collector = Role.create(name: "Collector")
      @boss = Role.create(name: "Boss")

      # A boss, clerk, and collector
      @fat_tony.roles << @boss
      @lou.roles << @clerk
      @eddie.roles << @collector

      Rental.destroy_all
      Vehicle.destroy_all

      # Vehicles
      @family_sedan = Vehicle.create(year: 2012, make: "Yugo", model: "Family Sedan")
      @mr_plow = Vehicle.create(year: 2013, make: "Skoda", model: "Mr. Plow")
      @the_homer = Vehicle.create(year: 2015, make: "Powell", model: "The Homer")
      @soap_box_racer = Vehicle.create(year: 2013, make: "Custom", model: "Soap Box Racer")
      @canyonero = Vehicle.create(year: 2012, make: "Powell", model: "Canyonero")
      @elec_taurus = Vehicle.create(year: 2014, make: "Ford", model: "Elec-Taurus")
      @book_burning_mobile = Vehicle.create(year: 2010, make: "Mercedes", model: "Book Burning Mobile")
      @lil_bandit = Vehicle.create(year: 1967, make: "Chevrolet", model: "Li'l Bandit")

      # Carl rented a car from Lou
      @rental1 = @carl.rented_cars.create(vehicle: @mr_plow, clerk: @lou, pick_up_time: Time.now - 1.day)
      # Carl returned the car an hour ago
      # With a full tank
      @rental1.update(collector: @eddie, drop_off_time: Time.now - 1.hour, odometer: 2000, fuel_level: 8)

      # Carl rented another car from Lou just now
      @rental2 = @carl.rented_cars.create(vehicle: @canyonero, clerk: @lou, pick_up_time: Time.now - 1.minute)

      # (For both of these rentals, Carl becomes the primary driver)
    end
  end
end
