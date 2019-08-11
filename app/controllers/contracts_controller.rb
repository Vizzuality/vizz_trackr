class ContractsController < ApplicationController
  def index
    @contracts = Contract.joins(:project).
      order("projects.name ASC, contracts.name ASC")
  end

  def show
    @contract = Contract.find(params[:id])
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
end
