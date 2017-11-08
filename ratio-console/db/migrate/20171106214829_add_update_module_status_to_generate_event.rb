class AddUpdateModuleStatusToGenerateEvent < ActiveRecord::Migration
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
      
      	DECLARE event_id INT;
      	
      	insert into device_events(device_id,module_id,state,ts)
      	values(FLOOR(mod_id/10),mod_id,st,UTC_TIMESTAMP());
      	
      	set event_id = LAST_INSERT_ID();
      	
      	update device_modules 
      	  set last_known_status = st, 
      	  last_known_status_datetime = UTC_TIMESTAMP()
      	where id = mod_id;
      	
      	return event_id;
      END
    )
  end
  def self.down 
    
  end
end
