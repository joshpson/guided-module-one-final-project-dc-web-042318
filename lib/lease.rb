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
    puts "Nice multi input experience."
  end

  def end_date
    self.start_date + self.length.month
  end

  def active?
    Time.now < self.end_date
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
