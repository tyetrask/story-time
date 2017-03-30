class Integration < ApplicationRecord
  belongs_to :user
  has_many :work_time_units, dependent: :destroy

  ALLOWED_SERVICE_TYPES = [
    'pivotaltracker.com',
    'jira.atlassian.com'
  ]

  validates :user_id, presence: true
  validates :service_type, presence: true, inclusion: { in: ALLOWED_SERVICE_TYPES }
  validates :token, presence: true

  def resource_interface
    case service_type
    when 'pivotaltracker.com'
      PivotalTrackerV5.new(token)
    when 'jira.atlassian.com'
      raise 'Not implemented'
    else
      raise "Unknown service type '#{service_type}'"
    end
  end

end
