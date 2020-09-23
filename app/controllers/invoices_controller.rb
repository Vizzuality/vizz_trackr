class InvoicesController < ApplicationController
  before_action :set_contract, only: [:index, :show, :edit, :update, :destroy]
  before_action :set_default_state, only: [:index]
  authorize_resource

  def index
    @invoices = Invoice.all.page(params[:page])
      .order('due_date ASC')
      .search(params[:contract]).page(params[:page])
    @invoices = @invoices.with_status(@state) unless @state == 'all'

    @states = Invoice.aasm.states.map{|s| s.to_s.humanize}.prepend(:all)
    @contracts = Contract.where(aasm_state: "live").order(:name).pluck(:name, :id).prepend(["all", :all])

    respond_to do |format|
      format.html
      format.csv do
        send_data @invoices.to_csv,
                  type: 'csv',
                  filename: "invoices-with-state-#{@state}.csv"
      end
    end
  end




  private

  def set_invoice
    @invoice = Invoice.find(params[:id])
  end

  def set_contract
    @contract = params[:contract].presence || 'all'
  end

  def set_default_state
    @state = params[:state].presence || 'all'
  end

  def invoice_params
    params.require(:invoice).permit(:id, :code, :name,
                                     :aasm_state, :state,
                                     :contract, :amount, :milestone,
                                     :due_date, :extended_date)
  end
end
