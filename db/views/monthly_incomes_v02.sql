SELECT
  sum(budget / (date_part('month',age(end_date, start_date)))) AS income,
  generate_series(date_trunc('month', start_date), end_date, '1 month')::date as month,
  aasm_state,
  contracts.id AS contract_id
  FROM contracts
  GROUP BY month, contract_id, aasm_state
  ORDER BY month DESC;

