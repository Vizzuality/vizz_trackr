desc "This task collects project yearly reports"
task year_report: :environment do
  puts "collecting info..."

  @year = 2020

  @years = ReportingPeriod
    .select("date_part('year', date)::INTEGER AS year")
    .distinct.order(year: :desc).map(&:year)

  @reporting_periods = ReportingPeriod
    .includes(:contracts, :full_reports)
    .where("date_part('year', date) = ?", @year)
    .order(:date)

  @contracts = Contract.joins(:full_reports)
    .where(full_reports: {reporting_period_id: @reporting_periods.uniq.pluck(:id)})
    .order(:name)
    .distinct

  @full_reports = FullReport
    .where(reporting_period_id: @reporting_periods.uniq.pluck(:id),
      contract_id: @contracts.uniq.pluck(:id))
    .select(:contract_id, :reporting_period_id, "SUM(cost) AS cost")
    .group(:contract_id, :reporting_period_id)

  CSV.open("statistics.csv", "wb") do |csv_file|
    header = %w[Contract].concat(@reporting_periods.map { |rp| rp.display_name })
    csv_file << header
    @contracts.each do |contract|
      contract_name = contract.name
      costs = []
      @reporting_periods.each do |rp|
        val = @full_reports.select { |fr| fr[:contract_id] == contract.id && fr[:reporting_period_id] == rp.id }&.first&.cost || 0.0
        costs << val.round(2)
      end
      csv_line = costs.prepend(contract_name)
      csv_file << csv_line
    end
  end
  puts "done."
end
