desc 'This task is called by the Heroku scheduler add-on to alert for invoices'
task raise_invoices: :environment do
  puts 'Updating invoices...'
  Invoice.where(aasm_state: 'scheduled', due_date: Time.zone.today - 1.day, extended_date: nil).or(Invoice.where(extended_date: Time.zone.today - 1.day)).each(&:raise_alert!)
  puts 'done.'
end
