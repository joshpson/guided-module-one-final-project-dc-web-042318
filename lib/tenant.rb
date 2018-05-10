class Tenant < ActiveRecord::Base
  has_many :leases
  has_many :units, through: :leases


  

  # Called by Lease.self_by_cli
  # Allows user to choose tenant for new lease
  # Prompts user to use an existing tenant or to create a new one. 
  def self.find_or_create
    puts "** Select Tenant for Lease ** \n\n"
    puts "(1) Existing Tenant"
    puts "(2) New Tenant?"
    puts "\n"
    print "Make your selection: "
    input = gets.chomp
    puts "\n"
    if input == "1"
      print "Please enter tenant's name: "
      name_query = gets.chomp.capitalize
      puts "\n"
      tenant_list = Tenant.where(name: name_query)
      tenant_list_ids = tenant_list.map {|tenant| tenant.id.to_s}
      if tenant_list.empty?
        puts "Name not found. Please try again.\n\n"
        self.find_or_create
      else
        tenant_list.each do |tenant|
        puts "Name: #{tenant.name}, Unique ID:#{tenant.id}"
        end
      end
      puts "\n"
      print "Enter unique id of tenant: "
      tenant_id = gets.chomp
      if !tenant_list_ids.include?(tenant_id)
        puts "Not a listed ID. Please try again.\n\n"
        self.find_or_create
      else
        tenant = Tenant.find(tenant_id)
        if !tenant
          puts "Not a valid ID, please try again.\n\n"
          self.find_or_create
        else
          puts "You have selected #{tenant.name}.\n"
          tenant
        end
      end
    elsif input == "2"
      puts "\n"
      new_tenant = self.new_by_options
    else
      puts "Incorrect input.\n"
      self.find_or_create
    end
  end

  # Called by Tenant.find_or_create
  # Allows user to create a new tenant
  def self.new_by_options
    puts "** Create a New Tenant **"
    print "Enter Tenant Name: "
    input_name = gets.chomp.capitalize
    print "Enter Tenant Age: "
    input_age = gets.chomp
    print "Enter Credit Score: "
    input_score = gets.chomp
    puts "\n"
    print "Create new tenant: #{input_name} - #{input_age} years old - #{input_score} credit score? (y/n): "
    input_confirm = gets.chomp
    if input_confirm.downcase == "n"
      puts "Returning to Create Lease. \n\n"
      Lease.new_by_cli
    elsif input_confirm.downcase == "y"
      new_tenant = Tenant.create(name: input_name, age: input_age, credit_score: input_score)
      puts "\n"
      puts "You have added #{new_tenant.name} as a Tenant."
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
        puts "#{tenant.name} - Unit Number: #{lease.unit.unit_number} - Lease End Date: #{lease.end_date}\n\n"
      end
    end
  end

  # Should return whether a tenant has a current lease?
  def current_lease
    self.leases.find {|lease| lease.active? }
  end


end
