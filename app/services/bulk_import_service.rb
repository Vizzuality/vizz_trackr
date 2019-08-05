require 'csv'

class BulkImportService
  attr_accessor :reporting_period, :file

  def initialize(reporting_period_id, file)
    @reporting_period = ReportingPeriod.find(reporting_period_id)
    @file = file
  end

  def call
    import_data
  end

  private

  def import_data
    successes = []
    failures = []
    CSV.read(@file, headers: true).each do |row|
      next unless row.first[1]
      name = row.first[1].split(',').map(&:strip)
      user = User.where(name: [name[1], name[0]].join(" ")).first
      if !user
        puts "No user found for #{row.first[1]}. Skipping..."
        next
      end
      report = @reporting_period.reports.new(user_id: user.id)
      report.role = user.role
      report.team = user.team
      row.to_a[1, row.size-1].each do |pair|
        next unless pair[1]
        project = Project.where("projects.name ilike '#{pair[0]}'").
          or(Project.where("projects.alias ilike '#{pair[0]}'")).first

        project = Project.joins(:contracts).where("contracts.name ilike '#{pair[0]}'").
          first if !project
        if !project
          failures << "Couldn't find a project with name #{pair[0]}. Skipping..."
          next
        else
          successes << "Found project #{project.name} with this value: #{pair[0]}"
        end
        val = pair[1].include?("%") ? pair[1].gsub("%", "").to_f : pair[1].to_f*100
        val = val
        report.report_parts.new(project_id: project.id,
                                percentage: val)
      end
      report.save!
    end
    puts "#####################################################"
    puts " SUCCESSES IMPORTS !!!!!! "
    successes.uniq.each do |s|
      puts s
    end
    puts "*****************************************************"
    puts " !!!!!! FAILURES IMPORTS !!!!!! "
    if failures.empty?
      puts "NONE"
    else
      failures.uniq.each do |s|
        puts s
      end
    end
  end
end
