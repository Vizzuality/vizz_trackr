# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_08_05_003119) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "projects", force: :cascade do |t|
    t.string "name"
    t.float "budget"
    t.date "start_date"
    t.date "end_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "alias"
  end

  create_table "report_parts", force: :cascade do |t|
    t.bigint "report_id", null: false
    t.bigint "project_id", null: false
    t.float "percentage"
    t.float "days"
    t.float "cost"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["project_id"], name: "index_report_parts_on_project_id"
    t.index ["report_id"], name: "index_report_parts_on_report_id"
  end

  create_table "reporting_periods", force: :cascade do |t|
    t.date "date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "reports", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "team_id"
    t.integer "role_id"
    t.bigint "reporting_period_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["reporting_period_id"], name: "index_reports_on_reporting_period_id"
    t.index ["role_id"], name: "index_reports_on_role_id"
    t.index ["team_id"], name: "index_reports_on_team_id"
    t.index ["user_id"], name: "index_reports_on_user_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.integer "team_id"
    t.integer "role_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.float "cost"
    t.index ["role_id"], name: "index_users_on_role_id"
    t.index ["team_id"], name: "index_users_on_team_id"
  end

  add_foreign_key "report_parts", "projects"
  add_foreign_key "report_parts", "reports"
  add_foreign_key "reports", "reporting_periods"
  add_foreign_key "reports", "roles"
  add_foreign_key "reports", "teams"
  add_foreign_key "reports", "users"
  add_foreign_key "users", "roles"
  add_foreign_key "users", "teams"
end
