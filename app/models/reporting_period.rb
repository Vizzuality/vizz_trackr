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

  def total_projects_reported_by role_id=nil, team_name=nil, threshold=nil
    selection = report_parts
    if team_name.present?
      selection = selection.joins(report: :team).
        where(teams: {name: team_name})
    end
    if role_id.present?
      selection = selection.joins(:report).
        where(reports: {role_id: role_id})
    end
    if threshold.present?
      selection = selection.where("percentage > #{threshold.to_f}")
    end
    selection.select(:project_id).distinct.count
  end
end
