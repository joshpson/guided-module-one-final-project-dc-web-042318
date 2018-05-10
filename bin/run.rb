require_relative '../config/environment'

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
  puts "* * * * * * * * * * * * * * *"
  puts "* Please enter 'exit' to    *"
  puts "* leave or 'menu' to access *"
  puts "* options at anytime.       *"
  puts "* * * * * * * * * * * * * * *\n\n"

end

# Prompts user for input to select from options.
def pick_option
  print "\nPlease select from Main Menu options: "
  input = take_input
  case input
  when "1","view property data"
    display_property_data #view property data
  when "2","view unit data"
    display_unit_data
  when "3","view active leases"
    display_active_leases
  when "4","view current tenants"
    display_current_tenants
  when "5","create lease"
    Lease.new_by_cli
  else
    puts "Incorrect input. Plese try again."
  end
  pick_option
end

def display_property_data
  puts "\nCurrent Monthly Income: $#{sprintf('%.2f', Unit.income)}"
  puts "Current Occupancy is: #{Unit.occupancy_percentage}%"
  puts "Units Occupied: #{Lease.active_lease_count}."
  puts "Units Vacant: #{Unit.count - Lease.active_lease_count}."
end

def display_unit_data
  print "Enter unit number: "
  unit = Unit.find_by_unit_number(take_input)
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

def display_active_leases
  puts "\nActive Leases: \n\n"
  Lease.active_leases.each do |lease|
    puts  "#{lease.unit.unit_number} - #{lease.tenant.first_name} - "\
          "#{sprintf('%.2f', lease.monthly_rent)} per month - "\
          "Start Date: #{lease.start_date} - "\
          "End Date: #{lease.end_date}"
  end
end

def display_current_tenants
  Tenant.all.each do |tenant|
    if tenant.current_lease
      lease = tenant.current_lease
      puts "#{tenant.first_name} - Unit Number: #{lease.unit.unit_number} - "\
      "Lease End Date: #{lease.end_date}\n\n"
    end
  end
end


###CREATE NEW LEASE

# def create_new_lease
#   tenant = cli_find_or_create_tenant
#   unit = cli_find_unit
#   lease_data = cli_create_lease
#   display_lease_confirmation(tenant, unit)
#   Lease.create()
# end

# def cli_find_or_create_tenant
#   existing_tenant? ? select_existing_tenant : Tenant.new_by_options
# end

# def exisiting_tenant?
#   puts "** Select Tenant for Lease ** \n\n"
#   puts "(1) Existing Tenant"
#   puts "(2) New Tenant?\n"
#   print "Make your selection: "
#   user_choice = take_input
#   if input == "1"
#     TRUE
#   elsif input == "2"
#     FALSE
#   else
#     puts "Incorrect input.\n"
#     create_new_lease
#   end
# end


# def select_existing_tenant
#   print "Please enter tenant's name: "
#   tenant_list = Tenant.where(name: take_input.capitalize)
#   display_tenant_list(tenant_list)
#   select_tenant_from_list
# end

# def select_tenant_from_list
#   print "Enter unique id of tenant: "
#   tenant_id = take_input
#   validate_id(tenant_id)
# end

# def validate_id(tenant_id)

# end

# def display_tenant_list(tenant_list)
#   if tenant_list.empty?
#     puts "Name not found. Please try again.\n\n"
#     exisiting_tenant?
#   else
#     tenant_list.each do |tenant|
#       puts "Name: #{tenant.name}, Unique ID:#{tenant.id}"
#     end
#   end
# end





#Takes input and lets a user exit or go to menu
def take_input
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
def start_program
  show_options
  pick_option
end

start_program




