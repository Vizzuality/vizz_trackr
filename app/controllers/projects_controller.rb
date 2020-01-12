class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]
  authorize_resource

  # GET /projects
  # GET /projects.json
  def index
    @projects = Project.order(:name)
      .includes(:team, contracts: [:full_reports])
  end

  # GET /projects/1
  # GET /projects/1.json
  def show; end

  # GET /projects/new
  def new
    @project = Project.new
    @teams = Team.order(:name)
    @project.contracts.build
  end

  # GET /projects/1/edit
  def edit
    @teams = Team.order(:name)
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
        format.html do
          @teams = Team.order(:name)
          render :new
        end
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html do
          @teams = Team.order(:name)
          render :edit
        end
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
    params.require(:project).permit(:name, :team_id, :is_billable,
                                    contracts_attributes: [:id, :name, :_destroy,
                                                           :budget, :alias_list,
                                                           :start_date, :end_date])
  end
end
