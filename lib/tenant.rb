class Tenant < ActiveRecord::Base
  has_many :leases
  has_many :units, through: :leases

  def self.list_all
    puts "Returns a fomatted list of tenants."
  end

  def self.pivot_count
    Tenant.where(credit_score: (600..1000)).group(:age).count
  end

  def self.pivot_unique
    Tenant.group(:credit_score).distinct.count(:credit_score)
  end

  # def self.pivot_average
  #   Tenant.group(:age).average(:credit_score)
  # end

  def self.pivot_average(param)
    Tenant.group(param).average(:credit_score)
  end

  def self.pivot
    Tenant.group(:age).count
  end

  def self.count_by(var)
    Tenant.group(var).count
  end





end
