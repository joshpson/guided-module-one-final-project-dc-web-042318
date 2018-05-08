class CreateUnits < ActiveRecord::Migration[5.0]
  def change
    create_table :units do |t|
      t.string  :unit_number
      t.decimal :base_rent
      t.integer :bedrooms
      t.boolean :pets
      t.integer :square_feet
    end
  end
end
