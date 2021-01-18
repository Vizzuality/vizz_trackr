module ReportingPeriodsHelper
  def event_color(state)
    case state
    when 'reactivate'
      'btn-primary'
    when 'terminate'
      'btn-warning'
    when 'activate'
      'btn-success'
    else
      'btn-success'
    end
  end

  # returns [value, projected::boolean] or nil
  def income_val contract, month, incomes
    val = incomes.find { |m| m.contract_id == contract.id && m.month == month }&.income
    return [val, false] if val
    return [contract.linear_income, true] if contract.latest_progress_report && month > contract.latest_progress_report.date && month < contract.end_date

    nil
  end

  def reporting_period_income rperiod, contract
    return nil unless contract.budget

    income = contract.monthly_incomes.where(reporting_period_id: rperiod.id).first
    return income.income if income

    if rperiod.date < contract.end_date &&
        (!contract.latest_progress_report || contract.latest_progress_report.date > rperiod.date)
      return contract.linear_income
    end

    nil
  end
end
