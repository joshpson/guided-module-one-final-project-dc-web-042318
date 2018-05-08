# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180508195450) do

  create_table "leases", force: :cascade do |t|
    t.integer  "unit_id"
    t.integer  "tenant_id"
    t.datetime "start_date"
    t.integer  "length"
    t.decimal  "monthly_rent"
  end

  create_table "tenants", force: :cascade do |t|
    t.string  "name"
    t.integer "credit_score"
    t.integer "age"
  end

  create_table "units", force: :cascade do |t|
    t.string  "unit_number"
    t.decimal "base_rent"
    t.integer "bedrooms"
    t.boolean "pets"
    t.integer "square_feet"
  end

end
