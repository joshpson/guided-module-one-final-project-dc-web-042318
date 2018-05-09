class Lease < ActiveRecord::Base
  belongs_to :unit
  belongs_to :tenant

  # Called from Main Menu (3. View Leases) to Display All Leases
  # Currently only showing Active Leases. Expired leases is empty.
  def self.list_all
    puts "\n"
    puts "Active Leases: \n\n"
    self.active_leases.each do |lease|
      puts "#{lease.unit.unit_number} - #{lease.tenant.name} - #{lease.monthly_rent} per month."
    end
    puts "\n"
    puts "Expired leases: \n\n"
  end

  # Called from Main Menu (5. Create Lease)
  # Gets all necessary inputs from user to create a lease.
  # Checks if inputs are valid (to an extent)
  # Creates hash "choices" with user inputs
  def self.new_by_cli
    choices = {}
    choices[:tenant] = Tenant.find_or_create
    puts "\n"
    puts "Please enter the lease start date."
    puts "Format: YYYY-MM-DD\n"
    choices[:start_date] = gets.chomp
    choices[:unit] = Unit.select_unit_for_lease(choices[:start_date])
    choices[:monthly_rent] = choices[:unit].base_rent
    puts "\n"
    puts "Please enter the lease length in months."
    choices[:length] = gets.chomp
    confirm_lease_creation(choices)
  end

  # Displays all new lease data entered by user for confirmation.
  # Allows user to confirm or abort.
  def self.confirm_lease_creation(choices)
    puts "Lease details:"
    puts "Unit: #{choices[:unit].unit_number}"
    puts "Start Date: #{choices[:start_date]}"
    puts "Tenant: #{choices[:tenant].name}"
    puts  "Rent: #{choices[:monthly_rent]}"
    puts  "Length: #{choices[:length]} months"
    puts  "ARE YOU READY! Y/N"
    decision = gets.chomp
    if decision.downcase == "y"
      Lease.create(choices)
    elsif decision.downcase == "n"
      puts "Returning to main menu....\n\n"
      start_program
    else
      puts "Please enter Y/N\n"
      self.confirm_lease_creation(choices)
    end
  end

  # Calculates lease end date. 
  def end_date
    self.start_date + self.length.month
  end

  # Returns boolean for whether a lease is active.
  # By default checks whether lease is active at Time.now.
  # Allows passing a date as an optional parameter.
  def active?(date=Time.now)
    date < self.end_date && date > self.start_date
  end

  # Returns array of active leases.
  # Allows passing a date as an optional parameter through to #active?(date=Time.now)
  def self.active_leases(date=Time.now)
    self.all.select do |lease|
      lease.active?(date)
    end
  end

  # Counts number of active leases. 
  # Allows passing a date as an optional paramter through to .active_leases(date=Time.now)
  def self.active_lease_count(date=Time.now)
    self.active_leases(date).count
  end

end
