class CreateDeviceDefinitionView < ActiveRecord::Migration
  def self.up
    execute %Q(
      CREATE OR REPLACE 
      SQL SECURITY INVOKER
      VIEW device_definition_view
      as
        select distinct 
          device_id
          ,module_id
          ,sensor_type_id
        from device_events d
        join device_event_sensors s on s.device_event_id = d.id;
    )
  end
  
  def self.down
    execute %(DROP VIEW IF EXISTS device_definition_view;)
  end
end
