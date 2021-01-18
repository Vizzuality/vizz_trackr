desc 'This task collects statistics per FA'
task fa_stat: :environment do
  puts 'collecting info...'
  contracts = Contract.live
  CSV.open('statistics.csv', 'wb') do |csv_file|
    csv_file << %w(Contract FA Days Percentage budget)
    contracts.each do |c|
      c.budget_lines.each do |bl|
        contract_name = c.name
        role = bl.role_id ? Role.find(bl.role_id).name : nil
        percentage = bl.percentage
        days = bl.days
        csv_line = [contract_name, role, days, percentage, (bl.percentage * c.budget) / 100]
        csv_file << csv_line
      end
    end
  end
  puts 'done.'
end
