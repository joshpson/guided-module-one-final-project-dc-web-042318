require 'byebug'

class Tenant < ActiveRecord::Base
  has_many :leases
  has_many :units, through: :leases


  # Called by Lease.self_by_cli
  # Allows user to choose tenant for new lease
  # Prompts user to use an existing tenant or to create a new one.
  def self.find_or_create_for_lease
    puts "** Select Tenant for Lease ** \n\n"
    puts "(1) Existing Tenant"
    puts "(2) New Tenant?\n"
    print "Make your selection: "
    input = CliApplication.take_input
    puts "\n\n"
    #byebug
    if input == "1"
      self.select_existing_tenant
    elsif input == "2"
      self.new_by_options
    else
      puts "Incorrect input.\n"
      self.find_or_create_for_lease
    end
  end

  def self.select_existing_tenant
    tenant_list = self.find_tenant_list_by_name
    self.display_tenant_list(tenant_list)
    tenant = nil
    while !tenant
      tenant = self.return_validated_tenant(tenant_list)
    end
  end

  def self.return_validated_tenant(tenant_list)
    print "\nEnter unique id of tenant: "
    tenant_id = CliApplication.take_input
    tenant_list_ids = tenant_list.map {|tenant| tenant.id.to_s}
    if !tenant_list_ids.include?(tenant_id)
      puts "Not a listed ID. Please try again.\n\n"
      nil
    else
      tenant = Tenant.find(tenant_id)
      puts "You have selected #{tenant.first_name}.\n"
      tenant
    end
  end

  def self.find_tenant_list_by_name
    print "Please enter tenant's first name: "
    name_query = CliApplication.take_input.capitalize
    puts "\n"
    tenant_list = Tenant.where(first_name: name_query)
    if tenant_list.empty?
      puts "Name not found. Please try again.\n\n"
      self.find_tenant_list_by_name
    else
      tenant_list
    end
  end

  def self.display_tenant_list(tenant_list)
      tenant_list.each do |tenant|
        puts "Name: #{tenant.first_name} #{tenant.last_name}, Unique ID:#{tenant.id}"
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
    puts "\n"
    print "Create new tenant: #{first_name} #{last_name} - #{input_age} years old - #{input_score} credit score? (y/n): "
    input_confirm = CliApplication.take_input
    if input_confirm.downcase == "n"
      puts "Returning to Create Lease. \n\n"
      Lease.new_by_cli
    elsif input_confirm.downcase == "y"
      new_tenant = Tenant.create(first_name: first_name, last_name: last_name, age: input_age, credit_score: input_score)
      puts "\n"
      puts "You have added #{new_tenant.first_name} #{new_tenant.last_name} as a Tenant."
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
        puts "#{tenant.first_name} {tenant.last_name}- Unit Number: #{lease.unit.unit_number} - Lease End Date: #{lease.end_date}"
      end
    end
  end

  # Should return whether a tenant has a current lease?
  def current_lease
    self.leases.find {|lease| lease.active? }
  end


end
