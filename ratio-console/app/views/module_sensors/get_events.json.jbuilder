json.events @events do |e|
  json.eid e.id
  json.ts e.ts
  json.value e.value
end
json.sensor_type @sensor_type