json.array!(@work_time_units) do |work_time_unit|
  json.extract! work_time_unit, :id, :integration_id, :integration_user_id, :project_id, :story_id, :started_at, :finished_at, :total_time_in_seconds
end
