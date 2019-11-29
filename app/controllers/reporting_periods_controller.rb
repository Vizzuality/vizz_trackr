class ReportingPeriodsController < ApplicationController
  before_action :set_reporting_period, only: [:show, :edit, :update, :reports,
                                              :destroy, :update_state]
  authorize_resource

  # GET /reporting_periods
  # GET /reporting_periods.json
  def index
    @reporting_periods = ReportingPeriod.order(date: :desc)
      .includes(:full_reports)
    @data = ::Api::Charts::ReportingPeriod.new(@reporting_periods)
      .reporting_periods_burn_data
  end

  # GET /reporting_periods/1
  # GET /reporting_periods/1.json
  def show
    @total_reporters = @reporting_period.full_reports
      .select(:user_id).distinct.count
    @total_project_reports = @reporting_period.total_contracts_reported
    @reports = @reporting_period.reports
      .joins(:user).order("users.name ASC")
  end

  def reports
    respond_to do |format|
      format.html do
        @roles = Role.order(:name)
        @reports = @reporting_period.full_reports
          .includes(:contract, :project).order(:user_name)

        @reports = @reports.for_role(params[:role_id]) if params[:role_id].present?
      end
      format.csv { send_data @reporting_period.to_csv,
                   type: 'csv', filename: "report-#{@reporting_period.display_name}.csv" }
    end
  end

  # GET /reporting_periods/new
  def new
    @reporting_period = ReportingPeriod.new
    @reporting_periods = ReportingPeriod.order(date: :desc)
  end

  # GET /reporting_periods/1/edit
  def edit
    @reporting_periods = ReportingPeriod.order(date: :desc)
  end

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

  def update_state
    respond_to do |format|
      if @reporting_period.public_send("#{reporting_period_params[:aasm_state]}!")
        format.html { redirect_to reporting_periods_path, notice: 'Reporting period was successfully updated.' }
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
    params.require(:reporting_period).permit(:date, :aasm_state)
  end
end
