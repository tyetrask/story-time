class WorkTimeUnit < ApplicationRecord
  belongs_to :integration
  has_one :user, through: :integration

  validates :integration, presence: true
  validates :integration_user_id, presence: true
  validates :story_id, presence: true
  validates :started_at, presence: true
  validates :finished_at, uniqueness: {scope: :integration, message: "There is another open Work Time Unit for this developer/project."}, if: Proc.new { |wtu| wtu.finished_at.nil? }

  before_save :align_start_and_finish_date, if: Proc.new { |wtu| wtu.started_at && wtu.finished_at }
  before_save :update_total_time_in_seconds, if: Proc.new { |wtu| wtu.started_at && wtu.finished_at }

  private

    def align_start_and_finish_date
      self.finished_at = self.finished_at.change({year: self.started_at.year, month: self.started_at.month, day: self.started_at.day})
    end

    def update_total_time_in_seconds
      self.total_time_in_seconds = (finished_at.to_i - started_at.to_i).abs
    end

end
