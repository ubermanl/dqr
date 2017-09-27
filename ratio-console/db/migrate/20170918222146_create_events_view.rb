class CreateEventsView < ActiveRecord::Migration
  def self.up
    execute %Q(
      CREATE OR REPLACE 
      SQL SECURITY INVOKER
      VIEW device_events_view
      as
        select *
        from device_events d
        join device_event_sensors s on s.device_event_id = d.id;
    )
  end
  
  def self.down
    execute %(DROP VIEW IF EXISTS device_events_view;)
  end
end
