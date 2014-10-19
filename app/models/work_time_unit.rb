class WorkTimeUnit < ActiveRecord::Base
  belongs_to :user
  
  before_save :calculate_total_time_in_seconds
  
  def calculate_total_time_in_seconds
    if started_at && finished_at
      total_time_in_seconds = ((finished_at - started_at) * 24 * 60 * 60).to_i
    end
  end
  
end
