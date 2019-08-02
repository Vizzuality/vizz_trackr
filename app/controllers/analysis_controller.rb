class AnalysisController < ApplicationController
  def index
    @roles = Role.order(:name)
    @reporting_periods = ReportingPeriod.order(:date).includes(reports: :report_parts)
  end
end
