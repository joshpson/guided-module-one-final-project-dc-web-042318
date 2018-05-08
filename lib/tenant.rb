class Tenant < ActiveRecord::Base
  has_many :leases
  has_many :units, through: :leases

  def self.list_all
    puts "Returns a fomatted list of tenants."
  end


end
