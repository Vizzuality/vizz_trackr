class AnalysisController < ApplicationController
  def index
    @roles = Role.order(:name)
    set_teams_and_members
    @role = Role.find(params[:role_id])
    if @role
      @roslings = @roslings.where(role_id: @role.id)
      @ks = @ks.where(role_id: @role.id)
    end
    @reporting_periods = ReportingPeriod.order(:date).includes(reports: :report_parts)
  end

  private

  def set_teams_and_members
    @rosling = Team.where(name: 'Rosling').first
    @k = Team.where(name: 'K').first
    @roslings = User.where(team_id: @rosling.id)
    @ks = User.where(team_id: @k.id)
  end
end
