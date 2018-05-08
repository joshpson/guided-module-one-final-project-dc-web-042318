class Unit < ActiveRecord::Base
  has_many :leases
  has_many :tenants, through: :leases

  def self.property_data
    income = 0
    Lease.active_leases.each do |lease|
      income += lease.monthly_rent
    end
    puts "Current Monthly Income: $#{income.to_s}"
    puts "Current Occupancy Is: #{self.occupancy * 100}%"
  end

  def self.unit_data(unit)
    puts "#{unit} is doing great."
  end

  def self.occupancy
    (Lease.active_lease_count.to_f / self.count.to_f)
  end


end
