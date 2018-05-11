class Unit < ActiveRecord::Base
  has_many :leases
  has_many :tenants, through: :leases

  #CLASS METHODS

  #Returns monthly property income
  def self.income
    income = 0
    Lease.active_leases.each do |lease|
      income += lease.monthly_rent.to_f
    end
    income
  end

  # Calculates Occupancy % and converts two decimals
  def self.occupancy_percentage
    (Lease.active_lease_count.to_f / self.count.to_f) * 100
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
    available_units.sort_by! {|unit| unit.unit_number}
    available_units.each do |unit|
      puts "Unit Number: #{unit.unit_number} - "\
      "Base Rent: $#{sprintf('%.2f', unit.base_rent)} - "\
      "Bedrooms: #{unit.bedrooms}"
    end
    puts "\nThe above units are available to lease.\n"
  end

  # Called by Unit.select_unit_for_lease(date)
  # Prompts user to select a unit by unit number.
  def self.select_by_number(date)
    print "Enter Unit Number: "
    input_unit = CliApplication.take_input
    unit = Unit.find_by_unit_number(input_unit)
    if !unit
      puts "Unit does not exist."
      self.select_by_number(date) #recursive
    elsif unit.available?(date)
      puts "\n"
      self.confirm_selection(unit)
    else
      puts "Unit is not available on this date."
      puts "Please select a new unit."
      self.select_by_number(date) #recurisve
      #possibly return more info on lease
    end
  end

  # Called by Unit.select_by_number
  # Shows user the unit they have selected for eventual lease creation.
  # Allows user to confirm, or restart unit selection.
  def self.confirm_selection(unit)
    puts "\nYou have selected #{unit.unit_number} - "\
    "Base Rent: $#{sprintf('%.2f', unit.base_rent)} - "\
    "Bedrooms: #{unit.bedrooms} - SF: #{unit.square_feet}."
    print "\n\nPlease Confirm (y/n): "
    input_confirm = CliApplication.take_input
    if input_confirm == "n"
      self.select_unit_for_lease #recursive
    elsif input_confirm == "y"
      puts "\nSelection of #{unit.unit_number} confirmed."
      unit
    else
      puts "Invalid selection, please try again."
      self.select_unit_for_lease #recurisve
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
