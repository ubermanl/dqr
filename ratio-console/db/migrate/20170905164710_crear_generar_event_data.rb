class CrearGenerarEventData < ActiveRecord::Migration
  def self.up
    execute %Q(
      CREATE PROCEDURE `generate_event_data`(
        	IN `evt_id` INT,
        	IN `st_id` INT,
        	IN `val` DECIMAL(8,4)
        )
        LANGUAGE SQL
        NOT DETERMINISTIC
        CONTAINS SQL
        SQL SECURITY INVOKER
        COMMENT ''
        BEGIN
        	insert into device_event_sensors(device_event_id, sensor_type_id, value)
        	values(evt_id,st_id,val);
        END
    )
  end
  def self.down
    execut 'drop procedure generate_event_data;'
  end
end
