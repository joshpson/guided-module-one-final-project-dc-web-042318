#Runs the cli interface
class CliApplication

  # Initializes Main Menu
  def self.show_options
    puts "* * * * * * * * * * * * * * *"
    puts "*         Main Menu         *"
    puts "* * * * * * * * * * * * * * *"
    puts "*  1. View Property Data    *"
    puts "*  2. View Unit Data        *"
    puts "*  3. View Current Leases   *"
    puts "*  4. View Current Tenants  *"
    puts "*  5. Create Lease          *"
    puts "* * * * * * * * * * * * * * *"
    puts "* Please enter 'exit' to    *"
    puts "* leave or 'menu' to access *"
    puts "* options at anytime.       *"
    puts "* * * * * * * * * * * * * * *\n\n"
  end

  # Prompts user for input to select from options.
  def self.pick_option
    print "\nPlease select from Main Menu options: "
    input = CliApplication.take_input
    case input
    when "1","view property data"
      display_property_data
    when "2","view unit data"
      display_unit_data
    when "3","view active leases"
      display_current_leases
    when "4","view current tenants"
      display_current_tenants
    when "5","create lease"
      Lease.new_by_cli
    else
      puts "Incorrect input. Plese try again."
    end
    pick_option
  end

  #Displays high level property data, pulling from Unit and Lease
  def self.display_property_data
    puts "\nCurrent Monthly Income: $#{sprintf('%.2f', Unit.income)}"
    puts "Current Occupancy is: #{Unit.occupancy_percentage}%"
    puts "Units Occupied: #{Lease.active_lease_count}."
    puts "Units Vacant: #{Unit.count - Lease.active_lease_count}."
  end

  #Displays individual unit data based on user input
  def self.display_unit_data
    print "Enter unit number: "
    unit = Unit.find_by_unit_number(CliApplication.take_input)
    if !unit
      puts "Not a unit, returning to main menu..."
    elsif !unit.available?
      active_lease = unit.active_lease
      puts "\nYou have selected: #{unit.unit_number}"
      puts "Leaseholder: #{active_lease.tenant.first_name}"
      puts "Rent: $#{sprintf('%.2f', active_lease.monthly_rent)}"
      puts "Lease End Date: #{active_lease.end_date}\n\n"
    else unit.available?
      puts "\n#{unit.unit_number} is Vacant."
    end
  end

  #Loops through active leases
  def self.active_leases
    puts "\nActive Leases: \n\n"
    Lease.active_leases.each do |lease|
      self.display_lease(lease)
    end
  end

  #Loops through upcoming leases
  def self.upcoming_leases
    puts "\nUpcoming Leases: \n\n"
    Lease.upcoming_leases.each do |lease|
      self.display_lease(lease)
    end
  end

  #Displays a formatted lease to the user if passed in the lease
  def self.display_lease(lease)
    puts "#{lease.unit.unit_number} - #{lease.tenant.first_name} - "\
      "$#{sprintf('%.2f', lease.monthly_rent)} per month - "\
      "Start Date: #{lease.start_date} - "\
      "End Date: #{lease.end_date}"
  end

  #Calls the active and current lease methods for display
  def self.display_current_leases
    active_leases
    upcoming_leases
  end

  #Displays all current tenants
  def self.display_current_tenants
    Tenant.all.each do |tenant|
      if tenant.current_lease
        lease = tenant.current_lease
        puts "#{tenant.first_name} - Unit Number: #{lease.unit.unit_number} - "\
        "Lease End Date: #{lease.end_date}"
      end
    end
  end

  #Takes input and lets a user exit or go to menu
  def self.take_input
    input = gets.chomp.downcase
    if input == "menu"
      start_program
    elsif input == "exit"
      exit!
    else
      input
    end
  end

  # Initializes Main Menu & Prompts User
  def self.start_program
    show_options
    pick_option
  end

end
