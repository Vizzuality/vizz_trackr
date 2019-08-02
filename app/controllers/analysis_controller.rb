class AnalysisController < ApplicationController
  def index
    @reporting_periods = ReportingPeriod.order(:date)
  end
end
