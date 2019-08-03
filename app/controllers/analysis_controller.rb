class AnalysisController < ApplicationController
  def index
    @roles = Role.order(:name)
    set_teams_and_members
    @role = Role.find(params[:role_id]) if params[:role_id].present?
    if @role
      @roslings = @roslings.where(role_id: @role.id)
      @ks = @ks.where(role_id: @role.id)
    end
    @data = ReportingPeriod.get_data_for(params)
    @reporting_periods = ReportingPeriod.order(:date)

    respond_to do |format|
      format.json { render json: @data.to_json }
      format.html { render 'index' }
    end
  end

  private

  def set_teams_and_members
    @rosling = Team.where(name: 'Rosling').first
    @k = Team.where(name: 'K').first
    @roslings = User.where(team_id: @rosling.id)
    @ks = User.where(team_id: @k.id)
  end
end
