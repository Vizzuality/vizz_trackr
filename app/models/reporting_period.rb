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
end
