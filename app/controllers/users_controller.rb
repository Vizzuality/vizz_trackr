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
  def show
    @data = []
    @user.projects.distinct.each do |p|
      entry = { name: p.name }
      entry[:data] = {}
      report_parts = @user.report_parts.
        includes(report: :reporting_period).
        where(project_id: p.id).
        joins(report: :reporting_period).
        order('reporting_periods.date ASC')
      report_parts = report_parts.where(reporting_periods: { id: params[:reporting_period_id] }) if params[:reporting_period_id].present?
      report_parts.each do |rp|
        entry[:data][rp.report.reporting_period.display_name] = rp.percentage
      end
      @data << entry if !entry[:data].empty?
    end

    @data.sort!{|a,b| Date.parse(a[:data].first[0]) <=> Date.parse(b[:data].first[0])}

    @reporting_periods = @user.reporting_periods.order(:date).distinct

    respond_to do |format|
      format.html
      format.json { render json: @data.to_json }
    end
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to :users, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html {
          set_entities
          render :new
        }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html {
          set_entities
          render :edit
        }
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
      params.require(:user).permit(:name, :team_id, :role_id, :cost)
    end
end
