class ExternalResourcesController < ApplicationController
  before_action :set_integration

  def current__user
    @user = @integration.resource_interface.get_current_user
    respond_to do |format|
      format.json { render json: @user }
    end
  end

  def notifications
    @my_notifications = @integration.resource_interface.get_notifications
    respond_to do |format|
      format.json { render json: @my_notifications }
    end
  end

  def projects
    @projects = @integration.resource_interface.get_projects
    respond_to do |format|
      format.json { render json: @projects }
    end
  end

  def epics
    @epics = @integration.resource_interface.get_epics(external_resource_params[:project_id])
    respond_to do |format|
      format.json { render json: @epics }
    end
  end

  def iterations
    @iterations = @integration.resource_interface.get_iterations(external_resource_params[:project_id])
    respond_to do |format|
      format.json { render json: @iterations }
    end
  end

  def stories
    @stories = @integration.resource_interface.get_stories(external_resource_params[:project_id], {})
    respond_to do |format|
      format.json { render json: @stories }
    end
  end

  def story
    @story = @integration.resource_interface.get_story(
      external_resource_params[:project_id],
      external_resource_params[:story_id]
    )
    respond_to do |format|
      format.json { render json: @story }
    end
  end

  def patch_story
    respond_to do |format|
      if @story = @integration.resource_interface.patch_story(
          external_resource_params[:project_id],
          external_resource_params[:story_id],
          story_params.to_h
        )
        format.json { render json: @story }
      else
        format.json { render json: [], status: :unprocessable_entity }
      end
    end
  end

  private

    def set_integration
      @integration = current_user.integrations.find(params[:id])
    end

    def external_resource_params
      params.permit(:project_id, :story_id)
    end

    def story_params
      params.require(:story).permit(:current_state, owner_ids: [])
    end

end
