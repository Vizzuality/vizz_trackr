class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :set_entities, only: [:edit, :new]

  # GET /users
  # GET /users.json
  def index
    @users = User.order(:name).includes(:team, :role)
  end

  # GET /users/1
  # GET /users/1.json
  # rubocop:disable Metrics/AbcSize
  def show
    @reporting_periods = ReportingPeriod.joins(:full_reports)
      .where(full_reports: {user_id: @user.id})
      .order(:date).distinct
    @data = []
    @reporting_periods.each do |rp|
      next if params[:reporting_period_id] && rp.id != params[:reporting_period_id].to_i

      rp.full_reports.for_user(@user.id).each do |report|
        entry = @data.select { |t| t[:name] == report[:contract_name] }.first
        unless entry
          entry = {name: report.contract_name}
          new_entry = true
        end
        entry[:data] = {} unless entry[:data]
        entry[:data][report.reporting_period_name] = report.percentage
        @data << entry if new_entry
      end
    end

    respond_to do |format|
      format.html
      format.json { render json: @data.to_json }
    end
  end
  # rubocop:enable Metrics/AbcSize

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit; end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    @user.skip_password_validation = true

    respond_to do |format|
      if @user.save
        format.html { redirect_to :users, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html do
          set_entities
          render :new
        end
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      @user.skip_password_validation = true
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html do
          set_entities
          render :edit
        end
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  def set_entities
    @teams = Team.order(:name)
    @roles = Role.order(:name)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:name, :email, :team_id, :role_id, :cost)
  end
end
