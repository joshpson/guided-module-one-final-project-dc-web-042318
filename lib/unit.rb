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

  def available?
    self.active_lease.empty?
  end

  def active_lease
    self.leases.select {|lease| lease.active? }
  end

  def self.select_unit_for_lease
    puts "** Select Unit for Lease ** \n\n"
    puts "1: Find by Unit Number"
    puts "2: Display Available Units"
    puts "\n"
    print "Make your selection: "
    input = gets.chomp
    if input == "1"
      self.select_by_number
    elsif input == "2"
      self.available_units
      self.select_by_number
    else
      puts "\n"
      puts "Invalid selection. Please try again."
      self.select_unit_for_lease
    end
  end

  def self.select_by_number
    print "Enter Unit Number: "
    input_unit = gets.chomp
    unit = Unit.find_by_unit_number(input_unit)
    # check if unit is available
    self.confirm_selection(unit)
  end

  def self.available_units
    available_units = Unit.all.select {|unit| unit.available? }
    available_units.each {|unit| puts "Unit Number: #{unit.unit_number}"}
    puts "\n"
    puts "The above units are available to lease."
    puts "\n"
  end

  def self.select_from_list
    #Display available units with unit.id
    #Get unit.id input
    #Find unit by id
    self.confirm_selection(unit)
  end



  def self.confirm_selection(unit)
    puts "You have selected #{unit.unit_number} - Base Rent: #{unit.base_rent} - Bedrooms: #{unit.bedrooms} - SF: #{unit.square_feet}."
    print "Please Confirm (y/n): "
    input_confirm = gets.chomp
    if input_confirm.downcase == "n"
      self.lease_select
    elsif input_confirm.downcase == "y"
      puts "Selection of #{unit.unit_number} confirmed."
      unit
    else
      puts "Invalid selection, please try again."
      self.lease_select
    end
  end

end
