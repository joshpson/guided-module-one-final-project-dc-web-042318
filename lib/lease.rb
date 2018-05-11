class Lease < ActiveRecord::Base
  belongs_to :unit
  belongs_to :tenant

  #CLASS METHODS

  # Called from Main Menu (5. Create Lease)
  # Gets all necessary inputs from user to create a lease.
  # Checks if inputs are valid (to an extent)
  # Creates hash "choices" with user inputs
  def self.new_by_cli
    choices = {}
    choices[:tenant] = Tenant.find_or_create_for_lease
    choices[:start_date] = self.start_date_validation
    choices[:unit] = Unit.select_unit_for_lease(choices[:start_date])
    print "\nPlease enter the lease length in months: "
    choices[:length] = CliApplication.take_input
    choices[:monthly_rent] = self.rent_adjusted(choices[:length], choices[:unit].base_rent)
    confirm_lease_creation(choices)
  end

  #Adjusts rent based on a tenant's lease length
  def self.rent_adjusted(length, base_rent)
    if length.to_i <= 6
      base_rent + 100
    elsif length.to_i <= 12
      base_rent
    else
      base_rent - 100
    end
  end

  #Confirms that the start date has not already passed
  #Parses a user's input and returns a custom error if not a date
  def self.start_date_validation
    print "Please enter the lease start date. (Format: YYYY-MM-DD): "
    begin
      date = Date.parse(CliApplication.take_input) #custom error
     rescue
      puts "Invalid date format. Please try again.\n\n"
      self.start_date_validation #recursive
    else
      if date < Time.now
        puts "Date has already past. Please try again.\n\n"
        self.start_date_validation #recursive
      else
        date
      end
    end
  end

  # Displays all new lease data entered by user for confirmation.
  # Allows user to confirm or abort.
  def self.confirm_lease_creation(choices)
    self.display_lease_details(choices)
    decision = CliApplication.take_input
    if decision == "y"
      Lease.create(choices)
      puts "\nYou have successfully created the lease!"
      puts "\nReturning to Main Menu...\n"
      CliApplication.start_program
    elsif decision == "n"
      puts "Returning to Main Menu....\n\n"
      CliApplication.start_program
    else
      puts "Please enter Y/N\n"
      self.confirm_lease_creation(choices) #recursive
    end
  end

  #Displays the details of the lease to the user
  #Preferably this would be moved to cli
  def self.display_lease_details(choices)
    puts "Final Lease details:\n\n"
    puts "Unit: #{choices[:unit].unit_number}"
    puts "Start Date: #{choices[:start_date]}"
    puts "Tenant: #{choices[:tenant].first_name}"
    puts "Rent: $#{sprintf('%.2f', choices[:monthly_rent])}"
    puts "Length: #{choices[:length]} months"
    print "\nComplete Lease? (y/n): "
  end

  # Returns array of active leases.
  # Allows passing a date as an optional parameter through to #active?(date=Time.now)
  def self.active_leases(date=Time.now)
    leases = self.all.select {|lease| lease.active?(date)}
    leases.sort_by{|lease| lease.unit.unit_number}
  end

  # Counts number of active leases.
  # Allows passing a date as an optional paramter through to .active_leases(date=Time.now)
  def self.active_lease_count(date=Time.now)
    self.active_leases(date).count
  end

  # Returns array of upcoming leases.
  # Allows passing a date as an optional parameter through to #upcoming?(date=Time.now)
  def self.upcoming_leases(date=Time.now)
    leases = self.all.select {|lease| lease.upcoming?(date)}
    leases.sort_by{|lease| lease.unit.unit_number}
  end

  # Calculates lease end date.
  def end_date
    self.start_date + self.length.month
  end

  #INSTANCE METHODS

  # Returns boolean for whether a lease is upcoming.
  # By default checks whether lease is upcoming at Time.now.
  # Allows passing a date as an optional parameter.
  def upcoming?(date=Time.now)
    date < self.start_date
  end

  # Returns boolean for whether a lease is active.
  # By default checks whether lease is active at Time.now.
  # Allows passing a date as an optional parameter.
  def active?(date=Time.now)
    date < self.end_date && date > self.start_date
  end

end
