class ReportingPeriod < ApplicationRecord
  has_many :reports
  has_many :report_parts, through: :reports

  def display_name
    date.strftime("%B %Y")
  end

  def total_projects_reported
    report_parts.select(:project_id).distinct.count
  end

  def total_time_reported
    report_parts.sum(:days)
  end

  # filters:
  #   - threshold
  #   - role_id
  def reports_filtered filters, team
    result = reports.where(team_id: team.id)
    if filters[:threshold].present?
      result = result.joins(:report_parts).
        where("report_parts.percentage >= ?", filters[:threshold].to_f)
    end
    if filters[:role_id].present?
      result = result.where(role_id: filters[:role_id].to_i)
    end
    result
  end

  def report_parts_filtered filters, team
    result = report_parts.joins(:report).where(reports: { team_id: team.id})
    if filters[:threshold].present?
      result = result.where("percentage >= ?", filters[:threshold].to_f)
    end
    if filters[:role_id].present?
      result = result.joins(:report).
        where(reports: { role_id: filters[:role_id].to_i })
    end
    result
  end

  def self.data_summary_frame filters
    data = {}
    ["K", "Rosling"].each do |name|
      t = Team.where(name: name).first
      next unless t
      entry = []
      ReportingPeriod.order(:date).each do |rp|
        filtered_reports = rp.reports_filtered(filters, t)
        filtered_report_parts = rp.report_parts_filtered(filters, t)
        entry << yield(rp, filtered_reports, filtered_report_parts)
      end
      data[name.to_sym] = entry
    end
    data
  end

  # filters:
  #   - threshold
  #   - role_id
  def self.get_means_data_for filters
    data_summary_frame(filters) do |rp, filtered_reports, filtered_report_parts|
      row = {}
      row[:date] = rp.display_name

      row[:sum_reports] = filtered_reports.count
      row[:sum_report_parts] = filtered_report_parts.count

      row[:diff_projects] = filtered_report_parts.select(:project_id).
        distinct.count

      row[:mean_projects] = (row[:sum_report_parts]/row[:sum_reports].to_f).
        round(2)

      parts_list = filtered_report_parts.group_by(&:report_id).
        map { |t| t[1].size}

      step = parts_list.inject(0){|accum, i| accum+(i-row[:mean_projects])**2}
      variance = step/(parts_list.length-1).to_f
      row[:variance] = variance.try(:round, 2)
      row[:stdev] = Math.sqrt(variance).try(:round, 2)
      row
    end
  end
end
