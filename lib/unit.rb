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

  def self.pivot_sum
    Unit.group(:bedrooms).sum(:base_rent)
  end

  def self.pets_count
    Unit.group(:pets).count
  end

  def self.sum_rent_by(var)
    Unit.group(var).sum(:base_rent)
  end


end
