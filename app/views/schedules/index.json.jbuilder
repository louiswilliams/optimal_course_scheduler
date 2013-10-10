json.array!(@schedules) do |schedule|
  json.extract! schedule, :name, :user_id, :year, :semester
  json.url schedule_url(schedule, format: :json)
end