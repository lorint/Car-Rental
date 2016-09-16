class CreateRental < ActiveRecord::Migration
  def change
    create_table :rentals do |t|
      t.datetime :pick_up_time
      t.datetime :drop_off_time
      t.references :customer, index: true  # , foreign_key: true
      t.references :clerk, index: true  # , foreign_key: true
      t.references :collector, index: true  # , foreign_key: true
      t.references :vehicle, index: true, foreign_key: true
    end
  end
end
