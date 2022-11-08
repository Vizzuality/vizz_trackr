class ProjectLinksController < ApplicationController
  before_action :set_project

  def edit
    @project.project_links.build
  end

  def update
    if @project.update(project_params)
      redirect_to @project
    else
      render :edit
    end
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(project_links_attributes: [:id, :title,
      :url, :link_type,
      :_destroy])
  end
end
