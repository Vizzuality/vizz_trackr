puts "\nWelcome to\n\n"
puts <<-EOF
██╗   ██╗██╗███████╗███████╗████████╗██████╗  █████╗  ██████╗██╗  ██╗███████╗██████╗
██║   ██║██║╚══███╔╝╚══███╔╝╚══██╔══╝██╔══██╗██╔══██╗██╔════╝██║ ██╔╝██╔════╝██╔══██╗
██║   ██║██║  ███╔╝   ███╔╝    ██║   ██████╔╝███████║██║     █████╔╝ █████╗  ██████╔╝
╚██╗ ██╔╝██║ ███╔╝   ███╔╝     ██║   ██╔══██╗██╔══██║██║     ██╔═██╗ ██╔══╝  ██╔══██╗
 ╚████╔╝ ██║███████╗███████╗   ██║   ██║  ██║██║  ██║╚██████╗██║  ██╗███████╗██║  ██║
  ╚═══╝  ╚═╝╚══════╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝
EOF
puts "\nThis seeds file will generate random data aimed a development and/or staging\n"\
  "environments. By defaul the seeds won't delete existing data. If you want to do that\n"\
  "use `rails db:seed:replant` or `rails db:reset`. Here we go!\n\n"

if Rails.env.production?
  puts "hmmmm, are you sure you want to add random data in production? If so you'll\n"\
    'need to edit the seeds file before you run the command... one can\'t be too careful!'
  return
end

## Create One Admin
puts "First let\'s add an Admin user account for you to use, we'll be very careless here\n"\
  "but this is not production, so it's OK!"

User.find_or_create_by!(email: 'admin@example.com') do |user|
  user.name = 'Admin Account'
  user.password = 'password'
  user.admin = true
end

puts "Account details are Username: admin@example.com, Password: password\n"\
  "(unless you already had this account created, in that case nothing was changed)."

puts '######################################'

## Create Rates
puts 'Now lets add some random rates.'
5.times do
  Rate.find_or_create_by!(code: Faker::Science.unique.element_symbol) do |rate|
    rate.value = Faker::Number.number(digits: 5)
  end
end
puts "And now we have #{Rate.count} rates."

puts '######################################'

## Create Teams
puts 'Time to add some teams, hope we get some cool names.'
4.times do
  Team.find_or_create_by!(name: Faker::Restaurant.unique.name)
end
puts "And now we have #{Team.count} teams."

puts '######################################'

## Create Functional Areas
puts 'Time for some functional areas!'
[:frontend, :backend, :science, :design, :project_manager, :research,
 :operations, :business_development].each do |role|
  Role.find_or_create_by!(name: role.to_s.titleize)
end
puts "And now we have #{Role.count} of those."

puts '######################################'

## Create bunch of users
puts "The most important part of a team are its people!\n"\
  "For ease of use everyone will have the same password: password."
rand(50..70).times do
  name = Faker::FunnyName.unique.two_word_name
  u = User.find_or_initialize_by(email: Faker::Internet.email(name: name, domain: 'example.com'),
                                 name: name) do |user|
    user.password = 'password'
    dedication = 1.0
    active = rand(1..20) > 1
  end
  u.rate = Rate.all.sample
  u.team = Team.all.sample
  u.role = Role.all.sample
  u.save!
end
puts "We now have #{User.count} users. Yay us!"

puts '######################################'

## Create Projects
## Create Contracts

puts 'Let\'s add some projects so that we can do some work...'
20.times do
  name = [Faker::Food.unique.dish,
          ['Watch', 'Pulse', 'Planet', 'for Impact', 'International'].sample].join(' ')
  project = Project.find_or_create_by!(name: name) do |p|
    p.team_id = Team.all.pluck(:id).sample
    p.is_billable = rand(1..4) > 1
  end
  rand(1..3).times do |i|
    c_name = "#{name} - Phase #{i}"
    Contract.find_or_create_by!(name: c_name, project_id: project.id) do |c|
      c.budget = Faker::Number.number(digits: [5,6].sample)
      start_date = Faker::Date.between(from: 3.years.ago, to: 1.month.from_now)
      c.start_date = start_date
      end_date = start_date + [3, 6, 12, 18].sample.months
      c.end_date = end_date
      c.aasm_state = if end_date < Date.today
                       :finished
                     elsif start_date > Date.today
                       :proposal
                     else
                       :live
                     end
      c.code = name.split(' ').map(&:first).join('')
      c.notes = Faker::Lorem.sentences(number: 1)
      c.summary = Faker::Lorem.sentences(number: 5)
    end
  end
end
puts "We now have #{Project.count} projects and #{Contract.count} contracts"

puts '######################################'

## Create Reporting Periods
puts 'Let\'s add the reporting periods that are needed'
start_date = Date.parse('01/10/2018')
end_date = 1.month.from_now.beginning_of_month
loop do
  ReportingPeriod.find_or_create_by!(date: start_date)
  break if start_date == end_date

  start_date += 1.month
end
ReportingPeriod.last.update(aasm_state: :active)
puts "We now have #{ReportingPeriod.count} reporting periods"

puts '######################################'

## Create Reports

## Create some Progress Reports

## Create Non Staff Costs
