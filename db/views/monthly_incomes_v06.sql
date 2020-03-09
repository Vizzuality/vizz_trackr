SELECT
  DISTINCT
  (budget * progress_reports.delta / 100) AS income,
  reporting_periods.date as month,
  contracts.aasm_state AS aasm_state,
  contracts.id AS contract_id,
  reporting_periods.id AS reporting_period_id
  FROM contracts
  INNER JOIN report_parts ON report_parts.contract_id = contracts.id
  INNER JOIN reports ON  reports.id = report_parts.report_id
  INNER JOIN reporting_periods ON reporting_periods.id = reports.reporting_period_id
  INNER JOIN progress_reports ON progress_reports.reporting_period_id = reporting_periods.id AND
    progress_reports.contract_id = contracts.id
  WHERE contracts.budget IS NOT NULL
  ORDER BY month DESC;
