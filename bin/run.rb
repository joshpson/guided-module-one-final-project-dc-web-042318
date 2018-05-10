require_relative '../config/environment'

old_logger = ActiveRecord::Base.logger
ActiveRecord::Base.logger = nil

# Welcome Property Manager
puts "\n\n Welcome to Property Manager!\n\n"

# Initializes Main Menu
def show_options
  puts "* * * * * * * * * * * * * * *"
  puts "*         Main Menu         *"
  puts "* * * * * * * * * * * * * * *"
  puts "*  1. View Property Data    *"
  puts "*  2. View Unit Data        *"
  puts "*  3. View Active Leases    *"
  puts "*  4. View Current Tenants  *"
  puts "*  5. Create Lease          *"
  puts "*  6. Exit                  *"
  puts "* * * * * * * * * * * * * * *"
  puts "* Type 'menu' at any time   *"
  puts "*  to return to main menu.  *"
  puts "* * * * * * * * * * * * * * *\n\n"

end

# Prompts user for input to select from options.
def pick_option
  puts "\n"
  print "Please select from Main Menu options: "
  input = take_input
  puts "\n"
  if input == "1" || input.downcase == "view property data"
    Unit.property_data
    pick_option
  elsif input == "2" ||input.downcase == "view unit data"
    Unit.unit_data
    pick_option
  elsif input == "3"|| input.downcase == "view active leases"
    Lease.view_active
    pick_option
  elsif input == "4" || input.downcase == "view current tenants"
    Tenant.view_active
    pick_option
  elsif input == "5" || input.downcase == "create lease"
    Lease.new_by_cli
    pick_option
  elsif input == "6" || input.downcase == "exit"
    puts "Thank you for using Property Manager! Good Bye."
    puts "\n\n"
    exit!
  else
    puts "Incorrect input. Plese try again."
    pick_option
  end
end

# def enable_exit(input)
#   exit! if input.downcase == "exit"
# end

def take_input
  input = gets.chomp
  if input.downcase == "menu"
    start_program
  elsif input.downcase == "exit"
    exit!
  else
    input.downcase
  end
end

# Initializes Main Menu & Prompts User
def start_program
  show_options
  pick_option
end

start_program




