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

ActiveRecord::Schema.define(version: 2018_10_11_082137) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "pm_users", primary_key: "username", id: :string, limit: 40, force: :cascade do |t|
    t.string "password", limit: 40
    t.string "service_platform", limit: 40
  end

  create_table "roles", id: false, force: :cascade do |t|
    t.string "role"
    t.string "endpoint"
    t.string "verbs"
  end

  create_table "service_platforms", primary_key: "name", id: :string, limit: 40, force: :cascade do |t|
    t.string "host", limit: 255
    t.string "type", limit: 40
    t.string "service_token", limit: 256
  end

  create_table "users", primary_key: "username", id: :string, force: :cascade do |t|
    t.string "name"
    t.string "password"
    t.string "email"
    t.string "role"
    t.string "status"
  end

end