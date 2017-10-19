json.extract! schedule, :id, :description, :inactive, :enabled, :created_at, :updated_at
json.url schedule_url(schedule, format: :json)
