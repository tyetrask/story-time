class WorkTimeUnit < ActiveRecord::Base
  belongs_to :user
  
  validates :user_id, presence: true
  validates :story_id, presence: true
  validates :started_at, presence: true
  
  before_save :align_start_and_finish_date
  def align_start_and_finish_date
    return unless self.started_at && self.finished_at
    self.finished_at = self.finished_at.change({year: self.started_at.year, month: self.started_at.month, day: self.started_at.day})
  end
  
  before_save :store_total_time_in_seconds
  def store_total_time_in_seconds
    return unless self.started_at && self.finished_at
    self.total_time_in_seconds = (finished_at - started_at).to_i
  end
  
  validate :cannot_have_multiple_open_work_time_records_for_given_story
  def cannot_have_multiple_open_work_time_records_for_given_story
    @user_open_work_time_units = WorkTimeUnit.where(user_id: user_id, finished_at: nil)
    errors.add(:started_at, "can't be set because this developer is already working on another story.") if @user_open_work_time_units.size > 1
  end
  
end
