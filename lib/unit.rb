class Unit < ActiveRecord::Base
  has_many :leases
  has_many :tenants, through: :leases

  #CLASS METHODS

  # Called from Main Menu (1. Property Data)
  # Provides high-level property data.
  def self.property_data
    income = 0
    Lease.active_leases.each do |lease|
      income += lease.monthly_rent.to_f
    end
    puts "Current Monthly Income: $#{sprintf('%.2f', income)}"
    puts "Current Occupancy is: #{self.occupancy * 100}%"
    puts "Units Occupied: #{Lease.active_lease_count}."\
    "Units Vacant: #{self.count - Lease.active_lease_count}."
  end

  # Called by Main Menu (2. Unit Data)
  # Should get unit number from user,
  # and return information on that unit.
  def self.unit_data
    print "Enter unit number: "
    unit_number = take_input
    unit = Unit.find_by(unit_number: unit_number)
    if !unit
      puts "Not a unit, returning to main menu..."
    elsif !unit.available?
      active_lease = unit.active_lease
      puts "\n"
      puts "You have selected: #{unit.unit_number}"
      puts "Leaseholder: #{active_lease.tenant.name}"
      puts "Rent: $#{sprintf('%.2f', active_lease.monthly_rent)}"
      puts "Lease End Date: #{active_lease.end_date}\n\n"
    else unit.available?
      puts "\n"
      puts "#{unit.unit_number} is Vacant."
    end
  end

  # def self.display_data
  #Idea for later
  # end

  # Calculates Occupancy %
  def self.occupancy
    (Lease.active_lease_count.to_f / self.count.to_f)
  end


  # Called by Lease.new_by_cli
  # Shows all units available when passed a date.
  # Prompts user to select a unit by unit_number.
  def self.select_unit_for_lease(date)
    self.show_available_units_by_date(date)
    self.select_by_number(date)
  end

  # Called by Unit.select_unit_for_lease(date)
  # Finds units that are available based on the date passed.
  def self.show_available_units_by_date(date)
    available_units = Unit.all.select {|unit| unit.available?(date) }
    puts "\n"
    available_units.each {|unit| puts "Unit Number: #{unit.unit_number}"}
    puts "\n"
    puts "The above units are available to lease."
    puts "\n"
  end

  # Called by Unit.select_unit_for_lease(date)
  # Prompts user to select a unit by unit number.
  def self.select_by_number(date)
    print "Enter Unit Number: "
    input_unit = take_input
    unit = Unit.find_by_unit_number(input_unit)
    if !unit
      puts "Unit does not exist."
      self.select_by_number(date)
    elsif unit.available?(date)
      puts "\n"
      self.confirm_selection(unit)
    else
      puts "Unit is not available on this date."
      puts "Please select a new unit."
      self.select_by_number(date)
      #possibly return more info on lease
    end
  end

  ##### NOT APPARENTLY IN USE? #######
  # def self.select_from_list
  #   #Display available units with unit.id
  #   #Get unit.id input
  #   #Find unit by id
  #   self.confirm_selection(unit)
  # end

  # Called by Unit.select_by_number
  # Shows user the unit they have selected for eventual lease creation.
  # Allows user to confirm, or restart unit selection.
  def self.confirm_selection(unit)
    puts "\n"
    puts "You have selected #{unit.unit_number} - Rent: $#{sprintf('%.2f', unit.base_rent)} - Bedrooms: #{unit.bedrooms} - SF: #{unit.square_feet}.\n\n"
    print "Please Confirm (y/n): "
    input_confirm = take_input
    if input_confirm.downcase == "n"
      self.select_unit_for_lease
    elsif input_confirm.downcase == "y"
      puts "\n"
      puts "Selection of #{unit.unit_number} confirmed."
      unit
    else
      puts "Invalid selection, please try again."
      self.select_unit_for_lease
    end
  end

  #INSTANCE METHODS

  # Boolean. Checks if unit is available.
  # Returns true if unit does not have an active lease based on an optional date passed.
  # Date defaults to Time.now when not given.
  # Called by Unit.show_available_units_by_date(date) and Unit.select_by_number
  def available?(date=Time.now)
    !self.active_lease(date)
  end

  # Called by #available?(date=Time.now)
  # Returns active leases associated with this unit.
  def active_lease(date=Time.now)
    self.leases.find {|lease| lease.active?(date) }
  end

end
