class CreateTenants < ActiveRecord::Migration[5.0]
  def change
    create_table :tenants do |t|
      t.string  :name
      t.integer :credit_score
      t.integer :age
    end
  end
end
