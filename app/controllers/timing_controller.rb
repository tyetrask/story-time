class TimingController < ApplicationController
  
  def index
    pivotal_access = PivotalTracker::APIV5.new(current_user.pivotal_api_token)
    @me = pivotal_access.get_me
    @pivotal_project = pivotal_access.get_projects[1]
    @pivotal_iterations = pivotal_access.get_iterations(@pivotal_project['id'])
    @my_work = pivotal_access.get_my_work(@pivotal_project['id'])
  end
  
end
