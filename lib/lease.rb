class Lease < ActiveRecord::Base
  belongs_to :unit
  belongs_to :tenant

  def self.list_all
    puts "\n"
    puts "Active Leases: \n\n"
    self.active_leases.each do |lease|
      puts "#{lease.unit.unit_number} - #{lease.tenant.name} - #{lease.monthly_rent} per month."
    end
    puts "\n"
    puts "Expired leases: \n\n"
  end

  def self.new_by_cli
    tenant = Tenant.find_or_create
    puts "\n"
    puts "Please enter the lease start date."
    puts "Format: YYYY-MM-DD\n"
    start_date = gets.chomp
    unit = Unit.select_unit_for_lease(start_date)
    puts "\n"
    puts "Please enter the lease length in months."
    lease_length = gets.chomp
    #ready to create lease
    #puts detils
    puts "Lease details:"
    puts "Unit: #{unit.unit_number}"
    puts "Start Date: #{start_date}"
    puts "Tenant: #{tenant.name}"
    puts  "Rent: #{unit.base_rent}"
    puts  "Length: #{lease_length} months"
    puts  "ARE YOU READY! Y/N"
    decision = gets.chomp
    if decision.downcase == "y"
      Lease.create(unit: unit, tenant: tenant, start_date: start_date, length: lease_length, monthly_rent: unit.base_rent)
    end

  end

  def end_date
    self.start_date + self.length.month
  end

  def active?(date=Time.now)
    date < self.end_date && date > self.start_date
  end

  def self.active_leases
    self.all.select do |lease|
      lease.active?
    end
  end

  def self.active_lease_count
    self.active_leases.count
  end

end
