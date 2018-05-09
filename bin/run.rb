require_relative '../config/environment'

old_logger = ActiveRecord::Base.logger
ActiveRecord::Base.logger = nil

#Welcome Property Manager
puts "\n\n Welcome to Property Manager!\n\n"

#Show options, .gets a number to determine option choice
puts "* * * * * * * * * * * * * * *"
puts "*  1. View Property Data    *"
puts "*  2. View Unit Data        *"
puts "*  3. View Leases           *"
puts "*  4. View Tenants          *"
puts "*  5. Create Lease          *"
puts "*  6. Exit                  *"
puts "* * * * * * * * * * * * * * *\n\n"

# def get_input
#   input = gets.chomp
# end


def pick_option
  puts "\n"
  print "Please select from the above options: "
  input = gets.chomp
  puts "\n"
  if input == "1" || input == "View Property Data" || input == "view property data"
    Unit.property_data
    pick_option
  elsif input == "2" || input == "View Unit Data" || input == "view unit data"
    print "Enter unit number: "
    unit_input = gets.chomp
    Unit.unit_data(unit_input)
    pick_option
  elsif input == "3" || input == "View Leases" || input == "view leases"
    Lease.list_all
    pick_option
  elsif input == "4" || input == "View Tenants" || input == "view tenants"
    Tenant.list_all
    pick_option
  elsif input == "5" || input == "Create Lease" || input == "create lease"
    Lease.new_by_cli
    pick_option
  elsif input == "6" || input == "Exit" || inputs == "exit"
    puts "Thank you for using Property Manager."
  else
    puts "Incorrect input. Plese try again."
    pick_option
  end
end

pick_option


