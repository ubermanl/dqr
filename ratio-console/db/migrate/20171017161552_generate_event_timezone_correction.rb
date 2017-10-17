class GenerateEventTimezoneCorrection < ActiveRecord::Migration
  def self.up
    execute %Q(DROP FUNCTION IF EXISTS `generate_event`)
    execute %Q(
     CREATE FUNCTION `generate_event`(
      	`mod_id` INT,
      	`st` INT
      )
      RETURNS INT
      LANGUAGE SQL
      NOT DETERMINISTIC
      CONTAINS SQL
      SQL SECURITY INVOKER
      COMMENT ''
      BEGIN
      	insert into device_events(device_id,module_id,state,ts)
      	values(FLOOR(mod_id/10),mod_id,st,UTC_TIMESTAMP());
      	
      	return LAST_INSERT_ID();
      END
    )
    execute %Q(UPDATE device_events set ts = CONVERT_TZ(ts, @@session.time_zone, '+00:00'))
  end
  def self.down 
    
  end
end
