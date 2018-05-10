class Lease < ActiveRecord::Base
  belongs_to :unit
  belongs_to :tenant

  # Called from Main Menu (3. View Leases) to Display All Leases
  # Currently only showing Active Leases. Expired leases is empty.
  def self.view_active
    puts "\n"
    puts "Active Leases: \n\n"
    self.active_leases.each do |lease|
      puts  "#{lease.unit.unit_number} - #{lease.tenant.name} - "\
            "#{sprintf('%.2f', lease.monthly_rent)} per month - "\
            "Start Date: #{lease.start_date} - "\
            "End Date: #{lease.end_date}"
    end
  end

  # Called from Main Menu (5. Create Lease)
  # Gets all necessary inputs from user to create a lease.
  # Checks if inputs are valid (to an extent)
  # Creates hash "choices" with user inputs
  def self.new_by_cli
    choices = {}
    choices[:tenant] = Tenant.find_or_create_for_lease
    puts "\n"
    choices[:start_date] = self.start_date_validation
    choices[:unit] = Unit.select_unit_for_lease(choices[:start_date])
    choices[:monthly_rent] = choices[:unit].base_rent
    puts "\n"
    print "Please enter the lease length in months: "
    choices[:length] = take_input
    confirm_lease_creation(choices)
  end

  def self.start_date_validation
    print "Please enter the lease start date. (Format: YYYY-MM-DD): "
    begin
      date = Date.parse(take_input)
     rescue
      puts "Invalid date format. Please try again.\n\n"
      self.start_date_validation
    else
      if date < Time.now
        puts "Date has already past. Please try again.\n\n"
        self.start_date_validation
      else
        date
      end
    end
  end

  # Displays all new lease data entered by user for confirmation.
  # Allows user to confirm or abort.
  def self.confirm_lease_creation(choices)
    puts "Final Lease details:\n\n"
    puts "Unit: #{choices[:unit].unit_number}"
    puts "Start Date: #{choices[:start_date]}"
    puts "Tenant: #{choices[:tenant].name}"
    puts  "Rent: #{choices[:monthly_rent]}"
    puts  "Length: #{choices[:length]} months"
    puts "\n"
    print  "Complete Lease? (y/n): "
    decision = take_input
    if decision.downcase == "y"
      Lease.create(choices)
      puts "\n"
      puts "You have successfully created the lease!"
      puts "\n"
      puts "Returning to Main Menu..."
      puts "\n\n"
      start_program
    elsif decision.downcase == "n"
      puts "Returning to Main Menu....\n\n"
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
    self.all.select {|lease| lease.active?(date)}
  end

  # Counts number of active leases.
  # Allows passing a date as an optional paramter through to .active_leases(date=Time.now)
  def self.active_lease_count(date=Time.now)
    self.active_leases(date).count
  end

end
