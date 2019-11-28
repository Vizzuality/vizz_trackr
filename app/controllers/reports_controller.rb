class ReportsController < ApplicationController
  before_action :set_report, only: [:show, :edit, :update, :destroy]

  # GET /reports
  # GET /reports.json
  def index
    @reports = Report.all
  end

  # GET /reports/1
  # GET /reports/1.json
  def show; end

  # GET /reports/new
  def new
    @reporting_periods = ReportingPeriod.order(:date)
    @users = User.order(:name)
    @contracts = Contract.order(:name)
    @roles = Role.order(:name)
    @teams = Team.order(:name)

    @report = if params[:reporting_period_id]
                ReportingPeriod.find(params[:reporting_period_id]).reports.new
              else
                Report.new
              end
    @report.report_parts.build
  end

  # GET /reports/1/edit
  def edit
    redirect_to user_url(current_user), notice: 'No Report available to edit'  and return unless @report
    @reporting_periods = ReportingPeriod.order(:date)
    @users = User.order(:name)
    @contracts = Contract.order(:name)
    @roles = Role.order(:name)
    @teams = Team.order(:name)
    authorize! :edit, @report
  end

  # POST /reports
  # POST /reports.json
  def create
    @report = Report.new(report_params)

    respond_to do |format|
      if @report.save
        format.html { redirect_to reporting_periods_url, notice: 'Report was successfully created.' }
        format.json { render :show, status: :created, location: @report }
      else
        format.html { render :new }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reports/1
  # PATCH/PUT /reports/1.json
  def update
    respond_to do |format|
      if @report.update(report_params)
        format.html { redirect_to reports_user_path(@report.user), notice: 'Report was successfully updated.' }
        format.json { render :show, status: :ok, location: @report }
      else
        format.html {
          @reporting_periods = ReportingPeriod.order(:date)
          @users = User.order(:name)
          @contracts = Contract.order(:name)
          @roles = Role.order(:name)
          @teams = Team.order(:name)
          render :edit
        }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reports/1
  # DELETE /reports/1.json
  def destroy
    @report.destroy
    respond_to do |format|
      format.html { redirect_to reports_url, notice: 'Report was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_report
    @report = params[:id].present? ? Report.find(params[:id]) : current_user.current_report
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def report_params
    params.require(:report).permit(:user_id, :team_id, :role_id,
                                   :reporting_period_id, :estimated,
                                   report_parts_attributes: [:id, :percentage,
                                                             :contract_id,
                                                             :_destroy])
  end
end
