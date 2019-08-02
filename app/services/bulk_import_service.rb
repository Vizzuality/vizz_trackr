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
        project = Project.where("name ilike '#{pair[0]}'").or(Project.where("alias ilike '#{pair[0]}'")).first
        if !project
          puts "Couldn't find a project with name #{pair[0]}. Skipping..."
          next
        else
          puts "Found project #{project.name} with this value: #{pair[0]}"
        end
        val = pair[1].gsub("%", "").to_f
        val = val <= 1.0 && val > 0.0 ? val *100 : val
        report.report_parts.new(project_id: project.id,
                                percentage: val)
      end
      report.save!
    end
  end
end
