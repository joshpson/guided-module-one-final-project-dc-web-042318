class Lease < ActiveRecord::Base
  belongs_to :unit
  belongs_to :tenant

  def self.list_all
    puts "Returns a formatted list of leases."
  end

  def self.new_by_cli
    puts "Nice multi input experience."
  end

  def end_date
    self.start_date + length.month
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
