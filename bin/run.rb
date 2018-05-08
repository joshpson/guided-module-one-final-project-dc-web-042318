require_relative '../config/environment'

old_logger = ActiveRecord::Base.logger
ActiveRecord::Base.logger = nil

#Welcome Property Manager
puts "Welcome!"
puts "Please select from the list of options below:"

#Show options, .gets a number to determine option choice
puts "1. View Property Data"
puts "2. View Unit Data"
puts "3. View Leases"
puts "4. View Tenants"
puts "5. Create Lease"
puts "**********\n\n"

# def get_input
#   input = gets.chomp
# end

def pick_option
  input = gets.chomp
  if input == "1"
    Unit.property_data
  elsif input == "2"
    puts "Enter unit number."
    unit_input = gets.chomp
    Unit.unit_data(unit_input)
  elsif input == "3"
    Lease.list_all
  elsif input == "4"
    Tenant.list_all
  elsif input == "5"
    Lease.new_by_cli
  else
    puts "Incorrect input. Plese try again."
  end
end

pick_option
