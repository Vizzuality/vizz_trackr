json.extract! project, :id, :name, :budget, :start_date, :end_date, :created_at, :updated_at
json.url project_url(project, format: :json)
