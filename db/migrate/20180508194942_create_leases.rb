class CreateLeases < ActiveRecord::Migration[5.0]
  def change
    create_table :leases do |t|
      t.integer   :unit_id
      t.integer   :tenant_id
      t.datetime  :start_date # CHANGE TO DATE DATATYPE
      t.integer   :length
      t.decimal   :monthly_rent
    end
  end
end
