class FaAllocationsController < ApplicationController
  before_action :set_default_state

  def index
    @contracts = Contract.joins(:budget_lines).group(:id)
    @contracts = @contracts.with_status(@state)
    @roles = Role.order(:id).pluck(:name, :id)
    @states = Contract.aasm.states.map(&:name)
    respond_to do |format|
      format.html
      format.csv do
        filename = "fa_allocation"
        send_data render_to_string(filename: filename)
      end
    end
  end

  private

  def set_default_state
    @state = params[:state].presence || "live"
  end
end
