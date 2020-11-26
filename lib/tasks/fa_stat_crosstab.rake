desc "This task collects statistics per FA in a crosstab"
task :fa_stat_cross => :environment do
  puts "collecting info..."
    contracts = Contract.joins(:budget_lines).live.group(:id)
    CSV.open("statistics.csv", "wb") do |csv_file|
      roles= Role.order(:id).pluck(:name)
      csv_file << %w(Contract).concat(roles)
      contracts.each do |c|
        budgets = []
        c.budget_lines.order(:role_id).each do |bl|
          budgets << bl.percentage
        end
        contract_name = c.name
        csv_line = budgets.prepend(contract_name)
        csv_file << csv_line
      end
    end
  puts "done."
end
