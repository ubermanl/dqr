class DeviceEventsViewFixup < ActiveRecord::Migration
  def self.up
    execute %Q(
      CREATE OR REPLACE 
      SQL SECURITY INVOKER
      VIEW device_events_view
      as
        select id
              ,device_id
              ,module_id
              ,cast(state as unsigned) state
              ,ts
              ,device_event_id
              ,sensor_type_id
              ,value
        from device_events d
        join device_event_sensors s on s.device_event_id = d.id;
    )
  end
  
  def self.down
    execute %(DROP VIEW IF EXISTS device_events_view;)
  end
end
