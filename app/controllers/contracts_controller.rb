class ContractsController < ApplicationController
  before_action :set_contract, only: [:show, :reports, :edit, :update,
                                      :team, :costs]
  before_action :set_default_state, only: [:index]
  authorize_resource

  def index
    @contracts = Contract.joins(:project).includes(:full_reports, :project)
      .order('projects.name ASC, contracts.name ASC')
    @states = Contract.aasm.states.map(&:name).prepend(:all)
    @contracts = @contracts.with_status(@state) unless @state == 'all'

    respond_to do |format|
      format.html
      format.csv do
        send_data @contracts.to_csv,
                  type: 'csv',
                  filename: "contracts-with-state-#{@state}.csv"
      end
    end
  end

  def new
    @contract = Contract.new
    @states = Contract.aasm.states.map(&:name).prepend(:all)
    @projects = Project.order(:name)
  end

  # POST /contracts
  # POST /contracts.json
  def create
    @contract = Contract.new(contract_params)

    respond_to do |format|
      if @contract.save
        format.html { redirect_to :contracts, notice: 'Contract was successfully created.' }
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
    @states = Contract.aasm.states.map(&:name).prepend(:all)
  end

  def show
    @roles = Role.order(:name)
    @days_per_role = @contract.full_reports
      .select('role_id, sum(days) AS days').group(:role_id)
    @total_days = @contract.full_reports.where.not(role_id: nil)
      .pluck('sum(days)').first

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
          if request.referrer == contracts_path
            redirect_to controller: 'contracts',
                        action: 'index',
                        state: params[:current_state].presence
          else
            redirect_to @contract, notice: 'Contract successfully updated!'
          end
        end
        format.json { render json: @contract, status: :ok }
      else
        format.html { render :edit }
        format.json { render json: @contract.errors, status: :unprocessable_entity }
      end
    end
  end

  # rubocop:disable Metrics/AbcSize
  def reports
    @reporting_periods = ReportingPeriod.joins(:full_reports)
      .where(full_reports: {contract_id: @contract.id})
      .order(:date).distinct
    @data = []
    @reporting_periods.each do |rp|
      next if params[:reporting_period_id] &&
        rp.id != params[:reporting_period_id].to_i

      rp.full_reports.for_contract(@contract.id).each do |report|
        entry = @data.select { |t| t[:name] == report.user_name }.first
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
  # rubocop:enable Metrics/AbcSize

  def costs
    @costs = @contract.full_reports
      .select('reporting_period_id, reporting_period_date, sum(cost) AS cost, report_estimated, TRUE as from_staff')
      .group(:reporting_period_id, :reporting_period_date, :reporting_period_name, :report_estimated)
      .order(reporting_period_date: :desc)
    @costs += @contract.non_staff_costs
      .joins(:reporting_period)
      .select('reporting_period_id, reporting_periods.date AS reporting_period_date,'\
        'sum(cost) AS cost, false as report_estimated, FALSE as from_staff')
      .group('reporting_period_id, reporting_periods.date')
      .order('reporting_periods.date DESC')
  end

  def team
    @team = @contract.full_reports
      .select('user_name, user_id, role_name, SUM(days) AS days')
      .group(:user_name, :user_id, :role_name)
      .order('SUM(days) DESC, user_name')
    @reporting_periods = ReportingPeriod
      .where('date > ?', (Date.today - 5.months).at_beginning_of_month)
      .order(:date).includes(:full_reports)
  end

  private

  def set_contract
    @contract = Contract.find(params[:id])
  end

  def set_default_state
    @state = params[:state].present? ? params[:state] : 'live'
  end

  def contract_params
    params.require(:contract).permit(:id, :code, :notes,
                                     :aasm_state, :state,
                                     :percent_complete, :project_id,
                                     :name, :budget, :summary,
                                     :alias_list, :start_date, :end_date)
  end
end
