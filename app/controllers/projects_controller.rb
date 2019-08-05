class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  # GET /projects
  # GET /projects.json
  def index
    @projects = Project.order(:name).includes(:report_parts)
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    @data = []
    @project.users.distinct.each do |u|
      entry = { name: u.name }
      entry[:data] = {}
      @project.report_parts.
        joins(report: :reporting_period).
        where(reports: {user_id: u.id}).
        order('reporting_periods.date ASC').each do |rp|
        entry[:data][rp.report.reporting_period.display_name] = rp.days
      end
      @data << entry
    end

    @data.sort!{|a,b| Date.parse(a[:data].first[0]) <=> Date.parse(b[:data].first[0])}

    respond_to do |format|
      format.html
      format.json { render json: @data.to_json }
    end
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)

    respond_to do |format|
      if @project.save
        format.html { redirect_to :projects, notice: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to :projects, notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:name, :budget, :start_date, :end_date, :alias)
    end
end
