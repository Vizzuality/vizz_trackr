class ResultsController < ApplicationController
  before_action :set_year

  # rubocop:disable Metrics/AbcSize
  def index
    @years = ReportingPeriod
      .select("date_part('year', date)::INTEGER AS year")
      .distinct.order(year: :desc).map(&:year)

    @reporting_periods = ReportingPeriod
      .includes(:contracts, :full_reports)
      .where("date_part('year', date) = ?", @year)
      .order(:date)

    @contracts = Contract.joins(:full_reports)
      .where(full_reports: {reporting_period_id: @reporting_periods.uniq.pluck(:id)})
      .order(:name)
      .distinct

    @full_reports = FullReport
      .where(reporting_period_id: @reporting_periods.uniq.pluck(:id),
             contract_id: @contracts.uniq.pluck(:id))
      .select(:contract_id, :reporting_period_id, 'SUM(cost) AS cost')
      .group(:contract_id, :reporting_period_id)

    @monthly_incomes = MonthlyIncome
      .where(reporting_period_id: @reporting_periods.uniq.pluck(:id),
             contract_id: @contracts.uniq.pluck(:id))
  end
  # rubocop:enable Metrics/AbcSize

  private

  def set_year
    @year = params[:year] || Time.now.year - 1
  end
end
