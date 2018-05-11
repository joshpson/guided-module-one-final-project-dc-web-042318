# PROPERTY MANAGER
Property Manager is a Command Line Interface (CLI) application, written in Ruby utilizing ActiveRecord and SQLite3, released under the MIT License. 

The project was developed by Josh Pearson and Lucas Eckman as part of the Flatiron School Software Engineering Immersive program in spring 2018. 

The application allows the property manager of a hypothetical 40-unit apartment building to create and manage leases and tenants, as well as view high-level property data including monthly income, occupancy, tenant and lease data. The data is stored in the relational database platform SQLite3, and accessed with Ruby methods through ActiveRecord. 

## Apartment “Units” are related to “Tenants” through the join table “Leases”. 
* A tenant has many leases, and many units through leases. 
* A unit has many leases, and many tenants through leases. 
* A lease belongs to a tenant and to a unit.

## From the main menu of the application, the user has five options:
1. View Property Data: View total monthly income and occupancy for the building.
2. View Unit Data: Enter a unit number and view its lease status and tenant information.
3. View Current Leases: View a list of active and upcoming leases and their information.
4. View Active Tenants: View a list of active tenants and their lease/unit information. 
5. Create Lease: Flagship feature. Create a new lease based on unit availability. 
    * Checks available units based on passed lease start date. 
    * Lease cannot start while the given unit has an active lease.
    * Lease cannot start in the past.
    * Create a lease with an existing tenant, or create a new tenant. 
    * Adjusts monthly rent based on lease length. (A short-term lease is more expensive, and a long-term lease is less expensive.)

## Seed Data 
Sample seed data is provided in the form of a CSV file that contains a table of past and present Tenant - Lease - Unit relationships for a 40-unit apartment building. Some tenants have renewed their past leases by signing new ones upon expiration of the prior lease.The db/seeds.rb file reads each row of the CSV and creates and associates each Tenant - Lease - Unit relationship. 



## Copyright 2018 Josh Pearson and Lucas Eckman

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.