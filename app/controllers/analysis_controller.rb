class AnalysisController < ApplicationController
  def index
    @roles = Role.order(:name)
    @data = ReportingPeriod.analyse(filter_params)

    respond_to do |format|
      format.json { render json: @data.to_json }
      format.html
      format.js
    end
  end

  private

  def filter_params
    params.permit(:threshold, :role_id)
  end

  def cache_key
    last_update = Report.maximum(:updated_at).strftime("%d%m%Y-%H%M")
    [
      "analysis",
      "role-#{params[:role_id].presence || "all"}",
      "threshold-#{params[:threshold].presence || "all"}",
      last_update
    ].join("-")
  end
end
