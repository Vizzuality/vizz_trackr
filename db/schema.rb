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

ActiveRecord::Schema.define(version: 2022_01_28_172109) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "budget_lines", force: :cascade do |t|
    t.bigint "contract_id", null: false
    t.bigint "role_id"
    t.float "percentage"
    t.string "details"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "days"
    t.float "adjusted_days"
    t.index ["contract_id"], name: "index_budget_lines_on_contract_id"
    t.index ["role_id"], name: "index_budget_lines_on_role_id"
  end

  create_table "contracts", force: :cascade do |t|
    t.string "name"
    t.bigint "project_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.float "budget"
    t.string "alias", default: [], array: true
    t.date "start_date"
    t.date "end_date"
    t.string "aasm_state"
    t.string "code"
    t.text "notes"
    t.text "summary"
    t.float "contract_rate", default: 175.0
    t.index ["alias"], name: "index_contracts_on_alias", using: :gin
    t.index ["project_id"], name: "index_contracts_on_project_id"
  end

  create_table "invoices", force: :cascade do |t|
    t.date "due_date"
    t.date "extended_date"
    t.text "milestone"
    t.date "invoiced_on"
    t.bigint "contract_id"
    t.text "observations"
    t.string "aasm_state"
    t.string "code"
    t.float "amount"
    t.string "currency", default: "dollar"
    t.index ["contract_id"], name: "index_invoices_on_contract_id"
  end

  create_table "non_staff_costs", force: :cascade do |t|
    t.float "cost", null: false
    t.bigint "contract_id", null: false
    t.string "cost_type", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "reporting_period_id", null: false
    t.string "details"
    t.index ["contract_id"], name: "index_non_staff_costs_on_contract_id"
    t.index ["reporting_period_id"], name: "index_non_staff_costs_on_reporting_period_id"
  end

  create_table "progress_reports", force: :cascade do |t|
    t.bigint "reporting_period_id", null: false
    t.bigint "contract_id", null: false
    t.float "percentage"
    t.float "delta"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["contract_id"], name: "index_progress_reports_on_contract_id"
    t.index ["reporting_period_id", "contract_id"], name: "index_progress_reports_on_reporting_period_id_and_contract_id", unique: true
  end

  create_table "project_links", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.string "title"
    t.string "url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "link_type"
    t.index ["project_id"], name: "index_project_links_on_project_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "team_id"
    t.boolean "is_billable", default: true
    t.index ["name"], name: "index_projects_on_name", unique: true
    t.index ["team_id"], name: "index_projects_on_team_id"
  end

  create_table "rates", force: :cascade do |t|
    t.string "code"
    t.float "value"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["code"], name: "index_rates_on_code", unique: true
  end

  create_table "report_parts", force: :cascade do |t|
    t.bigint "report_id", null: false
    t.float "percentage"
    t.float "days"
    t.float "cost"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "contract_id", null: false
    t.bigint "role_id"
    t.index ["contract_id", "report_id", "role_id"], name: "index_report_parts_on_contract_id_and_report_id_and_role_id", unique: true
    t.index ["contract_id"], name: "index_report_parts_on_contract_id"
    t.index ["report_id"], name: "index_report_parts_on_report_id"
    t.index ["role_id"], name: "index_report_parts_on_role_id"
  end

  create_table "reporting_periods", force: :cascade do |t|
    t.date "date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "aasm_state"
    t.float "base_rate", default: 175.0
    t.index ["date"], name: "index_reporting_periods_on_date", unique: true
  end

  create_table "reports", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "team_id"
    t.bigint "reporting_period_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "estimated", default: false
    t.index ["reporting_period_id"], name: "index_reports_on_reporting_period_id"
    t.index ["team_id"], name: "index_reports_on_team_id"
    t.index ["user_id"], name: "index_reports_on_user_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_roles_on_name", unique: true
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_teams_on_name", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.integer "team_id"
    t.integer "role_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.boolean "admin", default: false
    t.bigint "rate_id"
    t.float "dedication", default: 0.74, null: false
    t.boolean "active", default: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["rate_id"], name: "index_users_on_rate_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role_id"], name: "index_users_on_role_id"
    t.index ["team_id"], name: "index_users_on_team_id"
  end

  add_foreign_key "budget_lines", "contracts"
  add_foreign_key "budget_lines", "roles"
  add_foreign_key "contracts", "projects"
  add_foreign_key "invoices", "contracts"
  add_foreign_key "non_staff_costs", "contracts"
  add_foreign_key "non_staff_costs", "reporting_periods"
  add_foreign_key "progress_reports", "contracts"
  add_foreign_key "progress_reports", "reporting_periods"
  add_foreign_key "project_links", "projects"
  add_foreign_key "projects", "teams"
  add_foreign_key "report_parts", "contracts"
  add_foreign_key "report_parts", "reports"
  add_foreign_key "report_parts", "roles"
  add_foreign_key "reports", "reporting_periods"
  add_foreign_key "reports", "teams"
  add_foreign_key "reports", "users"
  add_foreign_key "users", "rates"
  add_foreign_key "users", "roles"
  add_foreign_key "users", "teams"

  create_view "full_reports", sql_definition: <<-SQL
      SELECT projects.id AS project_id,
      projects.name AS project_name,
      projects.is_billable AS project_is_billable,
      contracts.id AS contract_id,
      contracts.name AS contract_name,
      reporting_periods.id AS reporting_period_id,
      to_char((reporting_periods.date)::timestamp with time zone, 'MonthYYYY'::text) AS reporting_period_name,
      reporting_periods.date AS reporting_period_date,
      users.id AS user_id,
      users.name AS user_name,
      roles.id AS role_id,
      roles.name AS role_name,
      teams.id AS team_id,
      teams.name AS team_name,
      reports.id AS report_id,
      reports.estimated AS report_estimated,
      report_parts.percentage,
      report_parts.cost,
      report_parts.days
     FROM (((((((report_parts
       JOIN reports ON ((reports.id = report_parts.report_id)))
       JOIN contracts ON ((contracts.id = report_parts.contract_id)))
       JOIN reporting_periods ON ((reporting_periods.id = reports.reporting_period_id)))
       LEFT JOIN teams ON ((teams.id = reports.team_id)))
       LEFT JOIN users ON ((users.id = reports.user_id)))
       LEFT JOIN roles ON ((roles.id = report_parts.role_id)))
       JOIN projects ON ((projects.id = contracts.project_id)));
  SQL
  create_view "monthly_incomes", sql_definition: <<-SQL
      SELECT DISTINCT ((contracts.budget * progress_reports.delta) / (100)::double precision) AS income,
      reporting_periods.date AS month,
      contracts.aasm_state,
      contracts.id AS contract_id,
      reporting_periods.id AS reporting_period_id
     FROM ((((contracts
       JOIN report_parts ON ((report_parts.contract_id = contracts.id)))
       JOIN reports ON ((reports.id = report_parts.report_id)))
       JOIN reporting_periods ON ((reporting_periods.id = reports.reporting_period_id)))
       JOIN progress_reports ON (((progress_reports.reporting_period_id = reporting_periods.id) AND (progress_reports.contract_id = contracts.id))))
    WHERE (contracts.budget IS NOT NULL)
    ORDER BY reporting_periods.date DESC;
  SQL
end
