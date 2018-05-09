class Tenant < ActiveRecord::Base
  has_many :leases
  has_many :units, through: :leases

  def self.list_all
    puts "Returns a fomatted list of tenants."
  end

  def self.find_or_create
    puts "** Select Tenant for Lease ** \n\n"
    puts "(1) Existing Tenant"
    puts "(2) New Tenant?"
    puts "\n"
    print "Make your selection: "
    input = gets.chomp
    if input == "1"
      puts "Under Construction"
    elsif input == "2"
      puts "\n"
      new_tenant = self.new_by_options
    end
  end

  def self.new_by_options
    print "Enter Tenant Name: "
    input_name = gets.chomp
    print "Enter Tenant Age: "
    input_age = gets.chomp
    print "Enter Credit Score: "
    input_score = gets.chomp
    print "Create new tenant: #{input_name} - #{input_age} years old - #{input_score} credit score? (y/n)"
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


end
