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

  def total_projects_reported_by role_id=nil, team_id=nil
    selection = reports
    if team_id
      selection = selection.where(team_id: team_id)
    end
    if role_id.present?
      selection = selection.where(role_id: role_id)
    end
    selection.count
  end
end
