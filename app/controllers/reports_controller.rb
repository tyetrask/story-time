class ReportsController < ApplicationController
  before_action :set_scope
  
  def index
    # hey!
  end
  
  private
    
    def set_scope
      # TODO: Default range of one week, accept date params.
      return true
      @accepted_stories = @resource_interface.get_stories(story_interface_params[:project_id], {accepted_after: Date.now, accepted_before: Date.now})
    end
  
end
