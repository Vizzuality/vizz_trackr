class ReportingPeriodsController < ApplicationController
  before_action :set_reporting_period, only: [:show, :edit, :update, :destroy]

  # GET /reporting_periods
  # GET /reporting_periods.json
  def index
    @reporting_periods = ReportingPeriod.order(date: :desc)
      .includes(:full_reports)
    billable_burn = {name: 'Billable', data: {}}
    billable_projection = {name: 'Billable Projection', data: {}}
    non_billable_burn = {name: 'Non Billable', data: {}}
    non_billable_projection = {name: 'Non Billable Projection', data: {}}
    @reporting_periods.each do |rp|
      billable_burn[:data][rp.display_name] = rp.full_reports
        .where(project_is_billable: true, report_estimated: false).sum(:cost).round(2)
      billable_projection[:data][rp.display_name] = rp.full_reports
        .where(project_is_billable: true, report_estimated: true).sum(:cost).round(2)
      non_billable_burn[:data][rp.display_name] = rp.full_reports
        .where(project_is_billable: false).sum(:cost).round(2)
      non_billable_burn[:data][rp.display_name] = rp.full_reports
        .where(project_is_billable: false, report_estimated: false).sum(:cost).round(2)
      non_billable_projection[:data][rp.display_name] = rp.full_reports
        .where(project_is_billable: false, report_estimated: true).sum(:cost).round(2)
    end
    @data = [billable_burn, billable_projection,
             non_billable_burn, non_billable_projection]
  end

  # GET /reporting_periods/1
  # GET /reporting_periods/1.json
  def show
    @total_reporters = @reporting_period.full_reports
      .select(:user_id).distinct.count
    @total_project_reports = @reporting_period.total_contracts_reported
    @roles = Role.order(:name)

    @reports = @reporting_period.full_reports
      .includes(:contract, :project).order(:user_name)

    @reports = @reports.for_role(params[:role_id]) if params[:role_id].present?
  end

  # GET /reporting_periods/new
  def new
    @reporting_period = ReportingPeriod.new
    @reporting_periods = ReportingPeriod.order(date: :desc)
  end

  # GET /reporting_periods/1/edit
  def edit; end

  # POST /reporting_periods
  # POST /reporting_periods.json
  def create
    @reporting_period = ReportingPeriod.new(reporting_period_params)
    if params[:copy_reporting_period_id]
      source = ReportingPeriod.find(params[:copy_reporting_period_id])
      @reporting_period.copy_reports_from source
    end

    respond_to do |format|
      if @reporting_period.save
        format.html { redirect_to :reporting_periods, notice: 'Reporting period was successfully created.' }
        format.json { render :show, status: :created, location: @reporting_period }
      else
        format.html { render :new }
        format.json { render json: @reporting_period.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reporting_periods/1
  # PATCH/PUT /reporting_periods/1.json
  def update
    respond_to do |format|
      if @reporting_period.update(reporting_period_params)
        format.html { redirect_to @reporting_period, notice: 'Reporting period was successfully updated.' }
        format.json { render :show, status: :ok, location: @reporting_period }
      else
        format.html { render :edit }
        format.json { render json: @reporting_period.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reporting_periods/1
  # DELETE /reporting_periods/1.json
  def destroy
    @reporting_period.destroy
    respond_to do |format|
      format.html { redirect_to reporting_periods_url, notice: 'Reporting period was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_reporting_period
    @reporting_period = ReportingPeriod.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def reporting_period_params
    params.require(:reporting_period).permit(:date)
  end
end
