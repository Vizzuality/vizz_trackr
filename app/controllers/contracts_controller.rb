class ContractsController < ApplicationController
  before_action :set_contract, only: [:show, :reports, :costs]
  def index
    @contracts = Contract.joins(:project).includes(:full_reports, :project)
      .order('projects.name ASC, contracts.name ASC')
  end

  def show
    @contract = Contract.find(params[:id])
    @roles = Role.order(:name)
    @days_per_role = @contract.full_reports
      .select('role_id, sum(days) AS days').group(:role_id)
    @total_days = @contract.full_reports.where.not(role_id: nil)
      .pluck('sum(days)').first

    @data = ::Api::Charts::Contract.new(@contract).contract_burn_data
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
      .select('reporting_period_id, sum(cost) AS cost, report_estimated, TRUE as staff_costs')
      .group(:reporting_period_id, :reporting_period_name, :report_estimated)
      .order(Arel.sql("TO_DATE(reporting_period_name, 'MonthYYYY') ASC"))
    @costs += @contract.non_staff_costs
      .joins(:reporting_period)
      .select('reporting_period_id, sum(cost) AS cost, false as report_estimated, FALSE as staff_costs')
      .group('reporting_period_id, reporting_periods.date')
      .order('reporting_periods.date DESC')
  end

  private

  def set_contract
    @contract = Contract.find(params[:id])
  end
end
