class CrearGenerarEvento < ActiveRecord::Migration
  def self.up
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
      	values(FLOOR(mod_id/10),mod_id,st,now());
      	
      	return LAST_INSERT_ID();
      END
    )
  end
  def self.down 
    execute 'drop function generate_event;'
  end
end
