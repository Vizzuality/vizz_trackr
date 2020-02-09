class ProgressReportsController < ApplicationController
  before_action :set_contract
  before_action :set_progress_report, only: [:edit, :update], only: [:edit, :update]
  before_action :set_vars, only: [:new, :edit]

  def new
    @progress_report = @contract.progress_reports.new(reporting_period: @active_period)
  end

  def create
    @progress_report = @contract.progress_reports.new(progress_report_params)
    if @progress_report.save
      redirect_to @contract, notice: 'Progress report was successefully created.'
    else
      set_vars
      render :new
    end
  end

  def edit; end

  def update
    if @progress_report.update(progress_report_params)
      redirect_to @contract
    else
      set_vars
      render :edit
    end
  end

  private

  def set_progress_report
    @progress_report = ProgressReport.find(params[:id])
  end

  def set_contract
    @contract = Contract.find(params[:contract_id])
  end

  def set_vars
    @reporting_periods = ReportingPeriod.order(date: :desc)
    @active_period = ReportingPeriod.where(aasm_state: 'active').first
  end

  def progress_report_params
    params.require(:progress_report).permit(:reporting_period_id,
                                            :percentage)
  end
end
