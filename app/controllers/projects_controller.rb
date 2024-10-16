# class ProjectsController < ApplicationController
#     # GET /projects
#     def index
#       @projects = Project.all
#       render json: @projects
#     end
  
#     def create
#       @project = Project.new(project_params)
#       if @project.save
#         # Attach images if provided
#         if params[:project][:images].present?
#           params[:project][:images].each do |image|
#             @project.images.attach(image)
#           end
#         end
#         render json: @project, status: :created
#       else
#         render json: @project.errors, status: :unprocessable_entity
#       end
#     end
  
#     # GET /projects/:id
#     def show
#       @project = Project.find(params[:id])
#       render json: @project
#     end
  
#     # GET /projects/:id/media
#     def media
#       @project = Project.find(params[:id])
#       media_files = @project.images.map do |image|
#         {
#           filename: image.filename.to_s,
#           url: rails_blob_path(image, only_path: true)
#         }
#       end
#       render json: { media_files: media_files }
#     end
  
#     private
  
#     def project_params
#       params.require(:project).permit(:title, :description, images: [])
#     end
#   end
class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :update, :destroy, :media, :add_media, :remove_media]

  # GET /projects
  def index
          @projects = Project.all
          render json: @projects
        end
      

  # POST /projects
  def create
    @project = Project.new(project_params)
    if @project.save
      attach_media if params[:project][:images].present?
      render json: @project, status: :created
    else
      render json: { errors: @project.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # POST /projects/:id/add_media
  def add_media
    @project = Project.find(params[:id])

    if params[:media].present?
      params[:media].each do |media_file|
        @project.media.attach(media_file) # Attach each media file
      end
      render json: { message: 'Media uploaded successfully' }, status: :created
    else
      render json: { error: 'No media files provided' }, status: :unprocessable_entity
    end
  end
  # DELETE /projects/:id/remove_media/:media_id
  def remove_media
    media = @project.images.find_by(id: params[:media_id])
    if media
      media.purge
      render json: { success: "Media removed successfully" }, status: :ok
    else
      render json: { error: "Media not found" }, status: :not_found
    end
  end

  # GET /projects/:id
  def show
    render json: @project
  end

  # PUT /projects/:id
  def update
    if @project.update(project_params)
      attach_media if params[:project][:images].present?
      render json: @project
    else
      render json: { errors: @project.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /projects/:id
  def destroy
    @project.destroy
    head :no_content
  end

  # GET /projects/:id/media
  def media
    media_files = @project.images.map do |image|
      {
        id: image.id,
        filename: image.filename.to_s,
        content_type: image.content_type,
        url: rails_blob_path(image, only_path: true)
      }
    end
    render json: { media_files: media_files }
  end

  private

  def set_project
    @project = Project.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Project not found' }, status: :not_found
  end

  def project_params
    params.require(:project).permit(:title, :description, images: [])
  end

  # Attaching media (images or videos) to the project
  def attach_media
    params[:project][:images].each do |image|
      unless valid_file_type?(image)
        render json: { error: "Invalid file type for #{image.original_filename}" }, status: :unprocessable_entity
        return
      end
      @project.images.attach(image)
    end
  end

  # Validate file type for images or videos
  def valid_file_type?(file)
    allowed_types = %w[image/jpeg image/png video/mp4 video/mov]
    allowed_types.include?(file.content_type)
  end
end
