json.rows @events do |event|
  json.row render partial: 'events/event.html.erb', locals:{ event: event }
end