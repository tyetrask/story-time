class StoryInterfaceController < ApplicationController
  before_action :set_resource_interface
  
  def me
    @me = @resource_interface.get_me
    respond_to do |format|
      format.json { render json: @me }
    end
  end
  
  def my_notifications
    @my_notifications = @resource_interface.get_my_notifications
    respond_to do |format|
      format.json { render json: @my_notifications }
    end
  end
  
  def projects
    @projects = @resource_interface.get_projects
    respond_to do |format|
      format.json { render json: @projects }
    end
  end
  
  def epics
    @epics = @resource_interface.get_epics(story_interface_params[:project_id])
    respond_to do |format|
      format.json { render json: @epics }
    end
  end
  
  def iterations
    @iterations = @resource_interface.get_iterations(story_interface_params[:project_id])
    respond_to do |format|
      format.json { render json: @iterations }
    end
  end
  
  def my_work
    @my_work = @resource_interface.get_my_work(story_interface_params[:project_id])
    respond_to do |format|
      format.json { render json: @my_work }
    end
  end
  
  def stories
    @stories = @resource_interface.get_stories(story_interface_params[:project_id], {}) # Add ability to qualify options.
    respond_to do |format|
      format.json { render json: @stories }
    end
  end
  
  def story
    @story = @resource_interface.get_story(story_interface_params[:project_id], story_interface_params[:story_id])
    respond_to do |format|
      format.json { render json: @story }
    end
  end
  
  private
  
    def set_resource_interface
      if story_interface_params[:resource_interface] == 'pivotal_tracker'
        @resource_interface = PivotalTracker::APIV5.new(current_user.pivotal_api_token)
      elsif story_interface_params[:resource_interface] == 'jira'
        @resource_interface = nil
      else
        @resource_interface = nil
      end
    end
  
    def story_interface_params
      params.permit(:resource_interface, :project_id, :story_id)
    end
  
end
