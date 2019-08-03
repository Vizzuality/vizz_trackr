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
  #   - calculation
  def total_projects_reported_by team_id=nil, filters={}
    selection = report_parts
    if team_id
      selection = selection.joins(:report).where(reports: { team_id: team_id })
    end
    if filters[:role_id].present?
      selection = selection.joins(:report).
        where(reports: { role_id: filters[:role_id] })
    end
    if filters[:threshold].present?
      selection = selection.where("percentage > #{ filters[:threshold].to_f }")
    end
    my_count = selection.select(:project_id).distinct.count
    case filters[:calculation]
      when "total"
        return my_count
      when "avg"
        total = selection.select(:report_id).distinct.count
        return total.to_f/my_count
      else
        return my_count
    end
  end

  # filters:
  #   - threshold
  #   - role_id
  def reports_filtered filters
    result = reports
    if filters[:threshold].present?
      result = result.joins(:report_parts).
        where("report_parts.threshold >= ?", filters[:threshold].to_i)
    end
    if filters[:role_id].present?
      result = result.where(role_id: filters[:role_id].to_i)
    end
    result
  end

  def report_parts_filtered filters
    result = report_parts
    if filters[:threshold].present?
      result = result.where("threshold >= ?", filters[:threshold].to_i)
    end
    if filters[:role_id].present?
      result = result.joins(:report).
        where(reports: { role_id: filters[:role_id].to_i })
    end
    result
  end


  # filters:
  #   - threshold
  #   - role_id
  def self.get_data_for filters
    data = {}
    ["K", "Rosling"].each do |name|
      t = Team.where(name: name).first
      next unless t
      entry = []
      ReportingPeriod.order(:date).each do |rp|
        row = {}
        filtered_reports = rp.reports_filtered(filters)
        filtered_report_parts = rp.report_parts_filtered(filters)
        row[:date] = rp.display_name

        row[:sum_reports] = filtered_reports.where(team_id: t.id).count
        row[:diff_projects] = filtered_report_parts.joins(:report).
          where(reports: { team_id: t.id }).select(:project_id).distinct.count

        row[:sum_report_parts] = filtered_report_parts.joins(:report).
          where(reports: { team_id: t.id }).count
        row[:mean_projects] = (row[:sum_report_parts]/row[:sum_reports].to_f).round(2)

        parts_summary = filtered_report_parts.joins(:report).
          where(reports: { team_id: t.id } ).group_by(&:report_id).map { |t| t[1].size}
        step = parts_summary.inject(0){|accum, i| accum+(i-row[:mean_projects])**2}
        variance = step/(parts_summary.length-1).to_f
        row[:variance] = variance.round(2)
        row[:stdev] = Math.sqrt(variance).round(2)
        entry << row
      end
      data[name.to_sym] = entry
    end
    data
  end
end
