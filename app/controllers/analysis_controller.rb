class AnalysisController < ApplicationController
  def index
    @roles = Role.order(:name)
    @reporting_periods = ReportingPeriod.order(:date)

    @data = Rails.cache.fetch(cache_key, expires_in: 12.hours) do
      ReportingPeriod.get_data_for(params)
    end

    respond_to do |format|
      format.json { render json: @data.to_json }
      format.html { render 'index' }
    end
  end

  private

  def cache_key
    last_update = Report.maximum(:updated_at).strftime("%d%m%Y-%H%M")
    [
      "role-#{params[:role_id].presence || "all"}",
      "threshold-#{params[:threshold].presence || "all"}",
      last_update
    ].join("-")
  end
end
