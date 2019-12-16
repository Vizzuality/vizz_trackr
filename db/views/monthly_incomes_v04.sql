SELECT
  sum(budget / greatest(date_part('month',age(end_date, start_date)), 1)) AS income,
  generate_series(date_trunc('month', start_date), end_date, '1 month')::date as month,
  aasm_state,
  contracts.id AS contract_id
  FROM contracts
  INNER JOIN projects on projects.id = contracts.project_id
  WHERE projects.is_billable = true AND contracts.budget IS NOT NULL
  GROUP BY month, contract_id, aasm_state
  ORDER BY month DESC;

