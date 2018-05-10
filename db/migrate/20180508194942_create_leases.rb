class CreateLeases < ActiveRecord::Migration[5.0]
  def change
    create_table :leases do |t|
      t.integer   :unit_id
      t.integer   :tenant_id
      t.date      :start_date
      t.integer   :length
      t.decimal   :monthly_rent
    end
  end
end
