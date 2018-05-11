require 'csv'
require 'pry'

Lease.delete_all
Tenant.delete_all
Unit.delete_all

#

CSV.foreach("./db/pm-cli-data-2.csv") do |row|
    unit_number = row[0]
    unit_bedrooms = row[1]
    unit_square_feet = row[2]
    unit_base_rent = row[3]
    tenant_first = row[4]
    tenant_last = row[5]
    tenant_age = row[6]
    tenant_credit = row[7]
    lease_start = Date.parse(row[8])
    lease_length = row[9]
    tenant = Tenant.find_by(first_name: tenant_first, last_name: tenant_last)
    if !tenant
        tenant = Tenant.create(first_name: tenant_first, last_name: tenant_last, credit_score: tenant_credit, age: tenant_age)
    end
    unit = Unit.find_by(unit_number: unit_number)
    if !unit
        unit = Unit.create(unit_number: unit_number, base_rent: unit_base_rent, bedrooms: unit_bedrooms, square_feet: unit_square_feet)
    end
    lease = Lease.create(unit: unit, tenant: tenant, start_date: lease_start, length: lease_length, monthly_rent: unit.base_rent)
end



# unit101 = Unit.create(unit_number: "101", base_rent: "1300.00", bedrooms: "1", pets: "0", square_feet: "500")
# unit102 = Unit.create(unit_number: "102", base_rent: "1300.00", bedrooms: "1", pets: "0", square_feet: "500")
# unit103 = Unit.create(unit_number: "103", base_rent: "1300.00", bedrooms: "1", pets: "0", square_feet: "500")
# unit104 = Unit.create(unit_number: "104", base_rent: "1300.00", bedrooms: "1", pets: "0", square_feet: "500")
# unit105 = Unit.create(unit_number: "105", base_rent: "2000.00", bedrooms: "2", pets: "0", square_feet: "750")
# unit106 = Unit.create(unit_number: "106", base_rent: "2000.00", bedrooms: "2", pets: "0", square_feet: "750")
# unit107 = Unit.create(unit_number: "107", base_rent: "1300.00", bedrooms: "1", pets: "0", square_feet: "500")
# unit108 = Unit.create(unit_number: "108", base_rent: "1300.00", bedrooms: "1", pets: "0", square_feet: "500")
# unit109 = Unit.create(unit_number: "109", base_rent: "1300.00", bedrooms: "1", pets: "0", square_feet: "500")
# unit110 = Unit.create(unit_number: "110", base_rent: "2000.00", bedrooms: "2", pets: "0", square_feet: "750")

# alice = Tenant.create(name: "Alice", credit_score: "650", age: "25")
# bob = Tenant.create(name: "Bob", credit_score: "600", age: "30")
# carl = Tenant.create(name: "Carl", credit_score: "550", age: "40")
# denise = Tenant.create(name: "Denise", credit_score: "755", age: "29")
# ed = Tenant.create(name: "Ed", credit_score: "650", age: "17")
# frank = Tenant.create(name: "Frank", credit_score: "600", age: "25")
# gail = Tenant.create(name: "Gail", credit_score: "525", age: "20")
# hannah = Tenant.create(name: "Hannah", credit_score: "675", age: "55")
# isilde = Tenant.create(name: "Isilde", credit_score: "795", age: "65")
# jim = Tenant.create(name: "Jim", credit_score: "650", age: "25")
# kevin = Tenant.create(name: "Kevin", credit_score: "700", age: "16")
# lewis = Tenant.create(name: "Lewis", credit_score: "700", age: "20")
# mary = Tenant.create(name: "Mary", credit_score: "550", age: "35")
# nancy = Tenant.create(name: "Nancy", credit_score: "650", age: "28")
# oliver = Tenant.create(name: "Oliver", credit_score: "425", age: "25")

# lease1 = Lease.create(unit: unit101, tenant: alice, start_date: "2018-06-01", length: 6, monthly_rent: "1300.00")
# lease2 = Lease.create(unit: unit102, tenant: carl, start_date: "2017-06-01", length: 12, monthly_rent: "1400.00")
# lease3 = Lease.create(unit: unit104, tenant: gail, start_date: "2018-03-01", length: 24, monthly_rent: "1100.00")
# lease4 = Lease.create(unit: unit106, tenant: jim, start_date: "2018-02-01", length: 3, monthly_rent: "2400.00")
# lease5 = Lease.create(unit: unit110, tenant: mary, start_date: "2018-01-01", length: 12, monthly_rent: "1700.00")

