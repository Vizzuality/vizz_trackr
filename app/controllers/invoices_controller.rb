class InvoicesController < ApplicationController
  before_action :set_contract, only: [:index, :show, :edit, :destroy]
  before_action :set_default_state, only: [:index, :edit]
  before_action :set_invoice, only: [:edit, :show, :update, :destroy]
  before_action :set_contracts, only: [:new, :edit, :create, :update]
  before_action :set_states, only: [:new, :edit, :create, :update]
  authorize_resource

  def index
    invoices = Invoice.order('due_date ASC')
    invoices = invoices.search(params[:contract]) unless params[:contract] == 'all' 
    invoices = invoices.with_status(@state) unless @state == 'all'
    @invoices = invoices.page(params[:page])

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

  def new
    @invoice = Invoice.new
  end

  def edit
  end

  def update
    respond_to do |format|
      if @invoice.update(invoice_params)
        format.html { redirect_to @invoice, notice: 'Invoice successfully updated!' }
        format.json { render json: @invoice, status: :ok }
      else
        format.html { render :edit }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
  end

  def create
    @invoice = Invoice.new(invoice_params)
    respond_to do |format|
      if @invoice.save
        format.html { redirect_to @invoice, notice: 'Invoice successfully updated!'}
        format.json { render json: @invoice, status: :ok }
      else
        format.html { render :new }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if @invoice.destroy
      redirect_to request.referer
    else
      redirect_to request.referer, notice: @invoice.errors.full_messages.join(',')
    end
  end


  private

  def set_invoice
    @invoice = Invoice.find(params[:id])
  end

  def set_contracts
    @contracts = Contract.where(aasm_state: 'live').order(:name)
  end

  def set_contract
    @contract = params[:contract].presence || 'all'
  end

  def set_states
    @states = Invoice.aasm.states.map(&:name)
  end

  def set_default_state
    @state = params[:state].presence || 'all'
  end

  def invoice_params
    params.require(:invoice).permit(:id, :code, :name,
                                     :aasm_state, :state,
                                     :contract, :amount, :milestone, :currency,
                                     :due_date, :extended_date, 
                                     :contract_id, :observations, :invoiced_on)
  end
end
