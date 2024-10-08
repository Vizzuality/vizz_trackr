class ContractsController < ApplicationController
  before_action :set_contract, only: [:show, :reports, :edit, :update,
    :team, :costs, :destroy]
  before_action :set_default_state, only: [:index]
  before_action :set_states
  authorize_resource

  def index
    @contracts = Contract.joins(:project).includes(:full_reports, :project)
      .order("projects.is_billable DESC, projects.name ASC, contracts.name ASC")
      .search(params[:search]).page(params[:page])
    @contracts = @contracts.with_status(@state) unless @state == "all"

    @states = Contract.aasm.states.map(&:name).prepend(:all)

    respond_to do |format|
      format.html
      format.csv do
        send_data @contracts.to_csv,
          type: "csv",
          filename: "contracts-with-state-#{@state}.csv"
      end
    end
  end

  def new
    @contract = Contract.new
    @contract.build_budget_lines
    @states = Contract.aasm.states.map(&:name).prepend(:all)
    @projects = Project.order(:name)
  end

  # POST /contracts
  # POST /contracts.json
  def create
    @contract = Contract.new(contract_params)

    respond_to do |format|
      if @contract.save
        format.html do
          redirect_to contracts_path(state: @contract.aasm_state),
            notice: "Contract was successfully created."
        end
        format.json { render :show, status: :created, location: @contract }
      else
        format.html do
          @projects = Project.order(:name)
          render :new
        end
        format.json { render json: @contract.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @projects = Project.order(:name)
    @contract.build_budget_lines
  end

  def show
    @roles = Role.order(:name).includes(:budget_lines)
    @days_per_role = @contract.full_reports
      .select("role_id, sum(cost) AS cost, sum(days) AS days").group(:role_id)

    @data = if @contract.is_billable?
      ::Api::Charts::Contract.new(@contract).contract_burn_data
    else
      ::Api::Charts::Contract.new(@contract).days_spent_data
    end
  end

  def update
    respond_to do |format|
      if @contract.update(contract_params)
        format.html do
          if request.referer == contracts_url(state: params[:current_state])
            redirect_to contracts_path(state: params[:current_state]),
              notice: "Contract state successfully changed!"
          else
            redirect_to @contract, notice: "Contract successfully updated!"
          end
        end
        format.json { render json: @contract, status: :ok }
      else
        format.html { render :edit }
        format.json { render json: @contract.errors, status: :unprocessable_entity }
      end
    end
  end

  def reports
    @reporting_periods = ReportingPeriod.joins(:full_reports)
      .where(full_reports: {contract_id: @contract.id})
      .order(:date).distinct
    @data = []
    @reporting_periods.each do |rp|
      next if params[:reporting_period_id] &&
        rp.id != params[:reporting_period_id].to_i

      rp.full_reports.for_contract(@contract.id).each do |report|
        entry = @data.find { |t| t[:name] == report.user_name }
        unless entry
          entry = {name: report.user_name}
          new_entry = true
        end
        entry[:data] = {} unless entry[:data]
        entry[:data][report.reporting_period_name] = report.days
        @data << entry if new_entry
      end
    end
    @data.sort! { |a, b| b[:data].size <=> a[:data].size }
  end

  def costs
    @costs = @contract.full_reports
      .select("reporting_period_id, reporting_period_date, sum(cost) AS cost, report_estimated, TRUE as from_staff")
      .group(:reporting_period_id, :reporting_period_date, :reporting_period_name, :report_estimated)
      .order(reporting_period_date: :desc)
    @costs += @contract.non_staff_costs
      .joins(:reporting_period)
      .select("reporting_period_id, reporting_periods.date AS reporting_period_date," \
        "sum(cost) AS cost, false as report_estimated, FALSE as from_staff")
      .group("reporting_period_id, reporting_periods.date")
      .order("reporting_periods.date DESC")
  end

  def team
    @team = @contract.full_reports
      .select("user_name, user_id, role_name, SUM(days) AS days")
      .group(:user_name, :user_id, :role_name)
      .order("SUM(days) DESC, user_name")
    @reporting_periods = ReportingPeriod
      .where("date > ?", (Time.zone.today - 5.months).at_beginning_of_month)
      .order(:date).includes(:full_reports)
  end

  def destroy
    if @contract.destroy
      redirect_to request.referer
    else
      redirect_to request.referer, notice: @contract.errors.full_messages.join(",")
    end
  end

  private

  def set_contract
    @contract = Contract.find(params[:id])
  end

  def set_default_state
    @state = params[:state].presence || "live"
  end

  def set_states
    @states = Contract.aasm.states.map(&:name).prepend(:all)
  end

  def contract_params
    params.require(:contract).permit(:id, :code, :notes, :contract_rate,
      :aasm_state, :state,
      :project_id, :name, :budget, :summary,
      :start_date, :end_date,
      budget_lines_attributes: [:id, :percentage, :days,
        :adjusted_days,
        :role_id, :details])
  end
end
