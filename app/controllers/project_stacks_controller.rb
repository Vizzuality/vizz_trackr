class ProjectStacksController < ApplicationController
  # rubocop:disable Metrics/AbcSize
  def index
    @roles = Role.order(:name)
    @reporting_periods = ReportingPeriod.order(:date)

    @data = []

    projects = Project.where(id: ReportPart.select(:project_id).distinct.map(&:project_id))

    projects.each do |p|
      %w[K Rosling].each do |team|
        t = Team.where(name: team).first
        entry = {name: p.name, stack: t.name}
        entry[:data] = {}
        ReportPart.where(project_id: p.id)
          .joins(report: :reporting_period)
          .where(reports: {team_id: t.id})
          .order('reporting_periods.date ASC').each do |rp|
            the_name = rp.report.reporting_period.display_name
            entry[:data][the_name] = (entry[:data][the_name] || 0) + rp.days
          end
        @data << entry if entry[:data].present?
      end
    end

    respond_to do |format|
      format.json { render json: @data.to_json }
      format.html
      format.js
    end
  end
  # rubocop:enable Metrics/AbcSize

  private

  def cache_key
    last_update = Report.maximum(:updated_at).strftime('%d%m%Y-%H%M')
    [
      'project-stacks',
      "role-#{params[:role_id].presence || 'all'}",
      "threshold-#{params[:threshold].presence || 'all'}",
      last_update
    ].join('-')
  end
end
