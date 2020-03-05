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

    if contract.latest_progress_report && month > contract.latest_progress_report.date && month < contract.end_date
      return [contract.linear_income, true]
    end

    nil
  end

  def reporting_period_income rp, contract
    return nil unless contract.budget

    income = contract.monthly_incomes.where(reporting_period_id: rp.id).first
    return income.income if income

    if rp.date < contract.end_date && (!contract.latest_progress_report || contract.latest_progress_report.date > rp.date)
      return contract.linear_income
    end

    nil
  end
end
