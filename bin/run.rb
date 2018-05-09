require_relative '../config/environment'

old_logger = ActiveRecord::Base.logger
ActiveRecord::Base.logger = nil

# Welcome Property Manager
puts "\n\n Welcome to Property Manager!\n\n"

# Initializes Main Menu
def show_options
  puts "* * * * * * * * * * * * * * *"
  puts "*  1. View Property Data    *"
  puts "*  2. View Unit Data        *"
  puts "*  3. View Leases           *" # Currently Shows Active Leases Only
  puts "*  4. View Tenants          *"
  puts "*  5. Create Lease          *"
  puts "*  6. Exit                  *"
  puts "* * * * * * * * * * * * * * *\n\n"
end

# Prompts user for input to select from options.
def pick_option
  puts "\n"
  print "Please select from the above options: "
  input = gets.chomp
  puts "\n"
  if input == "1" || input.downcase == "view property data"
    Unit.property_data
    pick_option
  elsif input == "2" ||input.downcase == "view unit data"
    print "Enter unit number: "
    unit_input = gets.chomp
    Unit.unit_data(unit_input)
    pick_option
  elsif input == "3"|| input.downcase == "view leases"
    Lease.list_all
    pick_option
  elsif input == "4" || input.downcase == "view tenants"
    Tenant.list_all
    pick_option
  elsif input == "5" || input.downcase == "create lease"
    Lease.new_by_cli
    pick_option
  elsif input == "6" || input.downcase == "exit"
    puts "Thank you for using Property Manager."
  else
    puts "Incorrect input. Plese try again."
    pick_option
  end
end

# Initializes Main Menu & Prompts User
def start_program
  show_options
  pick_option
end

start_program




