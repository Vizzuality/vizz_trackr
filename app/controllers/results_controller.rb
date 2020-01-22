class ResultsController < ApplicationController
  before_action :set_year

  def index
    @years = ReportingPeriod
      .select("date_part('year', date)::INTEGER AS year")
      .distinct.order(year: :desc).map(&:year)
    @reporting_periods = ReportingPeriod
      .includes(:contracts, :full_reports)
      .where("date_part('year', date) = ?", @year)
      .order(:date)
    @contracts = @reporting_periods.flat_map(&:contracts).uniq.sort_by(&:name)
  end

  private

  def set_year
    @year = params[:year] || Time.now.year - 1
  end
end
