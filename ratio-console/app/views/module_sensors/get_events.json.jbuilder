json.events @events do |e|
  json.eid e.id
  json.ts e.ts
  json.value e.value
end