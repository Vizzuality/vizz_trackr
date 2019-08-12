class ContractsController < ApplicationController
  before_action :set_contract, only: [:show, :reports]
  def index
    @contracts = Contract.joins(:project).includes(:full_reports, :project).
      order("projects.name ASC, contracts.name ASC")
  end

  def show
    @contract = Contract.find(params[:id])
    agg = 0.0
    contract = { name: @contract.name, data: {}}
    aggregate = { name: "Aggregate", data: {}}
    @contract.full_reports.
      select("reporting_period_name, sum(cost) AS cost").
      group(:reporting_period_name).
      order("TO_DATE(reporting_period_name, 'MonthYYYY') ASC").each do |report|
        contract[:data][report.reporting_period_name] = report.cost
        agg += report.cost
        aggregate[:data][report.reporting_period_name] = agg
      end
    @data = [contract, aggregate]
  end

  def reports
    @reporting_periods = ReportingPeriod.joins(:full_reports).
      where(full_reports: { contract_id: @contract.id }).
      order(:date).distinct
    @data = []
    @reporting_periods.each do |rp|
      next if params[:reporting_period_id] &&
        rp.id != params[:reporting_period_id].to_i

      rp.full_reports.for_contract(@contract.id).each do |report|
        entry = @data.select{|t| t[:name] == report.user_name }.first
        if !entry
          entry = { name: report.user_name }
          new_entry = true
        end
        entry[:data] = {} unless entry[:data]
        entry[:data][report.reporting_period_name] = report.days
        @data << entry if new_entry
        new_entry = false
      end
    end
    @data.sort!{|a,b| b[:data].size <=> a[:data].size}
  end

  private

  def set_contract
    @contract = Contract.find(params[:id])
  end
end
