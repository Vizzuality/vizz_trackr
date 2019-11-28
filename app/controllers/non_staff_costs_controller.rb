class NonStaffCostsController < ApplicationController
  before_action :set_non_staff_cost, only: [:show, :edit, :update, :destroy]
  authorize_resource

  # GET /non_staff_costs
  # GET /non_staff_costs.json
  def index
    @non_staff_costs = NonStaffCost.all
  end

  # GET /non_staff_costs/1
  # GET /non_staff_costs/1.json
  def show; end

  # GET /non_staff_costs/new
  def new
    @non_staff_cost = NonStaffCost.new
    @contracts = Contract.order(:name)
    @reporting_periods = ReportingPeriod.order(date: :desc)
  end

  # GET /non_staff_costs/1/edit
  def edit
    @contracts = Contract.order(:name)
  end

  # POST /non_staff_costs
  # POST /non_staff_costs.json
  def create
    @non_staff_cost = NonStaffCost.new(non_staff_cost_params)

    respond_to do |format|
      if @non_staff_cost.save
        format.html { redirect_to non_staff_costs_path, notice: 'Non staff cost was successfully created.' }
        format.json { render :show, status: :created, location: @non_staff_cost }
      else
        format.html do
          @contracts = Contract.order(:name)
          @reporting_periods = ReportingPeriod.order(date: :desc)
          render :new
        end
        format.json { render json: @non_staff_cost.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /non_staff_costs/1
  # PATCH/PUT /non_staff_costs/1.json
  def update
    respond_to do |format|
      if @non_staff_cost.update(non_staff_cost_params)
        format.html { redirect_to @non_staff_cost, notice: 'Non staff cost was successfully updated.' }
        format.json { render :show, status: :ok, location: @non_staff_cost }
      else
        format.html do
          @contracts = Contract.order(:name)
          render :edit
        end
        format.json { render json: @non_staff_cost.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /non_staff_costs/1
  # DELETE /non_staff_costs/1.json
  def destroy
    @non_staff_cost.destroy
    respond_to do |format|
      format.html { redirect_to non_staff_costs_url, notice: 'Non staff cost was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_non_staff_cost
    @non_staff_cost = NonStaffCost.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def non_staff_cost_params
    params.require(:non_staff_cost).permit(:cost, :contract_id,
                                           :reporting_period_id,
                                           :date, :cost_type)
  end
end
