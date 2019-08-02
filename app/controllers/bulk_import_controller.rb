class BulkImportController < ApplicationController
  def new
    @reporting_period = ReportingPeriod.find(params[:reporting_period_id])
  end

  def create
    BulkImportService.new(params[:reporting_period_id], params[:file]).call
    redirect_to :reporting_periods
  end
end
