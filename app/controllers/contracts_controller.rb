class ContractsController < ApplicationController
  before_action :set_contract, only: [:show, :reports]
  def index
    @contracts = Contract.joins(:project).includes(:full_reports, :project)
      .order('projects.name ASC, contracts.name ASC')
  end

  def show
    @contract = Contract.find(params[:id])
    agg = 0.0
    contract = {name: 'Burn', data: {}}
    aggregate = {name: 'Aggregate', data: {}}
    projected = {name: 'Projected', data: {}}
    budget = {name: 'Budget', data: {}, points: false}
    @contract.full_reports
      .select('reporting_period_name, sum(cost) AS cost, report_estimated')
      .group(:reporting_period_name, :report_estimated)
      .order("TO_DATE(reporting_period_name, 'MonthYYYY') ASC").each do |report|
        if report.report_estimated?
          projected[:data][report.reporting_period_name] = report.cost
        else
          contract[:data][report.reporting_period_name] = report.cost
        end
        agg += report.cost
        aggregate[:data][report.reporting_period_name] = agg
        budget[:data][report.reporting_period_name] = @contract.budget&.to_f
      end
    @data = [contract, projected, aggregate, budget]
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

  private

  def set_contract
    @contract = Contract.find(params[:id])
  end
end
