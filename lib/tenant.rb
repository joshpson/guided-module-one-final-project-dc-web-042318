class Tenant < ActiveRecord::Base
  has_many :leases
  has_many :units, through: :leases

end
