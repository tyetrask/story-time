class WorkTimeUnit < ActiveRecord::Base
  belongs_to :user
  
  validates :user_id, presence: true
  validates :pivotal_story_id, presence: true
  validates :started_at, presence: true
  
  before_save :calculate_total_time_in_seconds
  def calculate_total_time_in_seconds
    if started_at && finished_at
      total_time_in_seconds = ((finished_at - started_at) * 24 * 60 * 60).to_i
    end
  end
  
  validate :cannot_have_multiple_open_work_time_records_for_given_story
  def cannot_have_multiple_open_work_time_records_for_given_story
    @work_time_units = WorkTimeUnit.where(pivotal_story_id: pivotal_story_id, finished_at: nil)
    errors.add(:started_at, "can't be set because another record for this story is already open.") if @work_time_units.size > 1
  end
  
end
