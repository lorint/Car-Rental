module SeedData
  # When this module is extended into a class or test...
  def self.extended(object)
    # ... make instance variables available.
    object.instance_exec do

      UserRole.destroy_all
      User.destroy_all
      Role.destroy_all

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

      @customer = Role.create(name: "Customer")
      @clerk = Role.create(name: "Clerk")
      @collector = Role.create(name: "Collector")
      @boss = Role.create(name: "Boss")
    end
  end
end
