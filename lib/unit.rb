class Unit < ActiveRecord::Base
  has_many :leases
  has_many :tenants, through: :leases

  #CLASS METHODS
  def self.unit_data(unit) #!!!!
    puts "#{unit} is doing great."
  end

  def self.occupancy
    (Lease.active_lease_count.to_f / self.count.to_f)
  end

  def self.property_data
    income = 0
    Lease.active_leases.each do |lease|
      income += lease.monthly_rent
    end
    puts "Current Monthly Income: $#{income.to_s}"
    puts "Current Occupancy Is: #{self.occupancy * 100}%"
    #probably want more data
  end

  def self.select_unit_for_lease(date)
    self.show_available_units_by_date(date)
    self.select_by_number(date)
  end

  def self.show_available_units_by_date(date)
    available_units = Unit.all.select {|unit| unit.available?(date) }
    available_units.each {|unit| puts "Unit Number: #{unit.unit_number}"}
    puts "\n"
    puts "The above units are available to lease."
    puts "\n"
  end

  def self.select_by_number(date)
    print "Enter Unit Number: "
    input_unit = gets.chomp
    unit = Unit.find_by_unit_number(input_unit)
    if !unit
      puts "Unit does not exist."
      self.select_by_number(date)
    elsif unit.available?(date)
      self.confirm_selection(unit)
    else
      puts "Unit is not available on this date."
      puts "Please select a new unit."
      self.select_by_number(date)
      #possibly return more info on lease
    end
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
      self.select_unit_for_lease
    elsif input_confirm.downcase == "y"
      puts "Selection of #{unit.unit_number} confirmed."
      unit
    else
      puts "Invalid selection, please try again."
      self.select_unit_for_lease
    end
  end

  #INSTANCE METHODS

  def available?(date=Time.now)
    !self.active_lease(date)
  end

  def active_lease(date=Time.now)
    self.leases.find {|lease| lease.active?(date) }
  end

end
