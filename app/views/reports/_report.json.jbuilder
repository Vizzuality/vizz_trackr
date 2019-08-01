json.extract! report, :id, :user_id, :team_id, :role_id, :reporting_period_id, :created_at, :updated_at
json.url report_url(report, format: :json)
