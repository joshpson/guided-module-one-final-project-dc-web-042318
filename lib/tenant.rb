class Tenant < ActiveRecord::Base
  has_many :leases
  has_many :units, through: :leases

  #CLASS METHODS

  # Called by Lease.self_by_cli
  # Allows user to choose tenant for new lease
  # Prompts user to use an existing tenant or to create a new one.
  def self.find_or_create_for_lease
    puts "\n** Select Tenant for Lease ** \n\n"
    puts "(1) Existing Tenant"
    puts "(2) New Tenant\n"
    print "\nMake your selection: "
    input = CliApplication.take_input
    puts "\n\n"
    if input == "1" || input == "existing tenant"
      self.select_existing_tenant
    elsif input == "2" || input == "new tenant"
      self.new_by_options
    else
      puts "Incorrect input.\n"
      self.find_or_create_for_lease #recursive
    end
  end

  #Displays a list of tenants and allows a user to select one
  def self.select_existing_tenant
    tenant_list = self.find_tenant_list_by_name
    self.display_tenant_list(tenant_list)
    tenant = nil
    #Continues to call return_validated_tenant until it
    #returns a tenant object
    while !tenant
      tenant = self.return_validated_tenant(tenant_list)
    end
    tenant
  end

  #Validates that a user selected a tenant from the list.
  #Will not allow any other selection.
  def self.return_validated_tenant(tenant_list)
    print "\nEnter unique id of tenant: "
    tenant_id = CliApplication.take_input
    tenant_list_ids = tenant_list.map {|tenant| tenant.id.to_s}
    if !tenant_list_ids.include?(tenant_id)
      puts "Not a listed ID. Please try again.\n\n"
      nil #returns nill back to the while loop in select_exisisting_tenant
    else
      tenant = Tenant.find(tenant_id)
      puts "\nYou have selected #{tenant.first_name}.\n\n"
      tenant
    end
  end

  #Create and returns a list of tenants based on first name input
  def self.find_tenant_list_by_name
    print "Please enter tenant's first name: "
    name_query = CliApplication.take_input.capitalize
    puts "\n"
    tenant_list = Tenant.where(first_name: name_query)
    if tenant_list.empty?
      puts "Name not found. Please try again.\n\n"
      self.find_tenant_list_by_name #recursive
    else
      tenant_list
    end
  end

  #Displays a list of tenants
  def self.display_tenant_list(tenant_list)
      tenant_list.each do |tenant|
        puts "Name: #{tenant.first_name} #{tenant.last_name} - "\
        "Current Unit: #{tenant.current_unit} - Tenant Unique ID: #{tenant.id}"
      end
  end

  # Called by Tenant.find_or_create_for_lease
  # Allows user to create a new tenant
  def self.new_by_options
    puts "** Create a New Tenant **"
    print "Enter Tenant First Name: "
    first_name = CliApplication.take_input.capitalize
    print "Enter Tenant Last Name: "
    last_name = CliApplication.take_input.capitalize
    print "Enter Tenant Age: "
    input_age = CliApplication.take_input
    print "Enter Credit Score: "
    input_score = CliApplication.take_input
    print "\nCreate new tenant: #{first_name} #{last_name} - "\
    "#{input_age} years old - #{input_score} credit score? (y/n): "
    input_confirm = CliApplication.take_input
    if input_confirm == "n"
      puts "Returning to Create Lease. \n\n"
      Lease.new_by_cli
    elsif input_confirm == "y"
      tenant_input = {
        first_name: first_name,
        last_name: last_name,
        age: input_age,
        credit_score: input_score
      }
      new_tenant = Tenant.create(tenant_input)
      puts "\nYou have added #{new_tenant.first_name} "\
      "#{new_tenant.last_name} as a Tenant."
      new_tenant
    else
      puts "Invalid entry, please try again."
    end
  end

  # Called by Main Menu (4. View Tenants)
  # Should return a formatted list of tenants and their info.
  def self.view_active
    self.all.each do |tenant|
      if tenant.current_lease
        lease = tenant.current_lease
        puts "#{tenant.first_name} {tenant.last_name} - "\
        "Unit Number: #{lease.unit.unit_number} - "\
        "Lease End Date: #{lease.end_date}"
      end
    end
  end

  #INSTANCE METHODS

  # Should return whether a tenant has a current lease?
  def current_lease
    self.leases.find {|lease| lease.active? }
  end

  def current_unit
    if self.current_lease
      self.current_lease.unit.unit_number
    else
      "n/a"
    end
  end

end
