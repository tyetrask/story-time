class TimingController < ApplicationController
  
  def index
    respond_to do |format|
      format.html {}
      format.json { 
        pivotal_access = PivotalTracker::APIV5.new(current_user.pivotal_api_token)
        @me = pivotal_access.get_me
        @pivotal_project = pivotal_access.get_projects[1]
        @pivotal_iterations = pivotal_access.get_iterations(@pivotal_project['id'])
        @my_work = pivotal_access.get_my_work(@pivotal_project['id'])
        render json: {me: @me, pivotal_project: @pivotal_project, pivotal_iterations: @pivotal_iterations, my_work: @my_work}
      }
    end
  end
  
end
