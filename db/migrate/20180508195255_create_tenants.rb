class CreateTenants < ActiveRecord::Migration[5.0]
  def change
    create_table :tenants do |t|
      t.string  :first_name
      t.string  :last_name
      t.integer :credit_score
      t.integer :age
    end
  end
end
