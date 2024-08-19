class ProjectsController < ApplicationController
    # GET /projects
    def index
      @projects = Project.all
      render json: @projects
    end
  
    def create
      @project = Project.new(project_params)
      if @project.save
        # Attach images if provided
        if params[:project][:images].present?
          params[:project][:images].each do |image|
            @project.images.attach(image)
          end
        end
        render json: @project, status: :created
      else
        render json: @project.errors, status: :unprocessable_entity
      end
    end
  
    # GET /projects/:id
    def show
      @project = Project.find(params[:id])
      render json: @project
    end
  
    # GET /projects/:id/media
    def media
      @project = Project.find(params[:id])
      media_files = @project.images.map do |image|
        {
          filename: image.filename.to_s,
          url: rails_blob_path(image, only_path: true)
        }
      end
      render json: { media_files: media_files }
    end
  
    private
  
    def project_params
      params.require(:project).permit(:title, :description, images: [])
    end
  end
  