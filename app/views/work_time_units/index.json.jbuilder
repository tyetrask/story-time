json.array!(@work_time_units) do |work_time_unit|
  json.extract! work_time_unit, :id, :user_id, :story_id, :started_at, :finished_at, :total_time_in_seconds
  json.url work_time_unit_url(work_time_unit, format: :json)
end
