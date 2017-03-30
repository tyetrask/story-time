class WorkTimeUnit < ApplicationRecord
  belongs_to :integration

  validates :integration, presence: true
  validates :integration_user_id, presence: true
  validates :story_id, presence: true
  validates :started_at, presence: true

  before_save :align_start_and_finish_date
  def align_start_and_finish_date
    return unless self.started_at && self.finished_at
    self.finished_at = self.finished_at.change({year: self.started_at.year, month: self.started_at.month, day: self.started_at.day})
  end

  before_save :update_total_time_in_seconds
  def update_total_time_in_seconds
    return unless self.started_at && self.finished_at
    self.total_time_in_seconds = (finished_at - started_at).to_i
  end

  validate :cannot_have_multiple_open_work_time_units_for_given_story
  def cannot_have_multiple_open_work_time_units_for_given_story
    @user_open_work_time_units = WorkTimeUnit.where(integration_user_id: integration_user_id, finished_at: nil)
    if @user_open_work_time_units.size > 1
      errors.add(:started_at, "can't be set because this developer is already working on another story.")
      throw(:abort)
    end
  end

end
