desc "This task is called by the Heroku scheduler add-on to alert for invoices"
task :raise_invoices => :environment do
  puts "Updating invoices..."
  Invoice.where(aasm_state: "scheduled", due_date: Date.today, extended_date: nil).or(Invoice.where(extended_date: Date.today - 15.days)). each do |i|
    i.raise_alert!
  end
  puts "done."
end
