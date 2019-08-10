SELECT
  projects.id AS project_id,
  projects.name AS project_name,
  contracts.id AS contract_id,
  contracts.name AS contract_name,
  reporting_periods.id AS reporting_period_id,
  to_char(reporting_periods.date, 'MonthYYYY') AS reporting_period_name,
  users.id AS user_id,
  users.name AS user_name,
  roles.id AS role_id,
  roles.name AS role_name,
  teams.id AS team_id,
  teams.name AS team_name,
  report_parts.percentage AS percentage,
  report_parts.cost AS cost,
  report_parts.days AS days
FROM report_parts
JOIN reports ON reports.id = report_parts.report_id
JOIN contracts ON contracts.id = report_parts.contract_id
JOIN reporting_periods ON reporting_periods.id = reports.reporting_period_id
JOIN teams ON teams.id = reports.team_id
JOIN users ON users.id = reports.user_id
JOIN roles ON roles.id = reports.role_id
JOIN projects ON projects.id = contracts.project_id

