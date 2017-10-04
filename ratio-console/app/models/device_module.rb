class DeviceModule < ActiveRecord::Base
  belongs_to :device
  belongs_to :module_type
  
  has_many :sensors, class_name: 'ModuleSensor', dependent: :destroy
  
  has_many :events, class_name:'DeviceEventView', foreign_key: :module_id
  
  def last_event
    self.events.order(ts: :desc).first
  end
  
  def last_status
    @last_status ||= events.order(ts: :desc).first
    @last_status
  end
  
  def active?
    last_status.state == 1 || last_status.state == 3
  end
  def inactive?
    last_status.state == 0 || last_status.state == 2
  end
  
  def override_active?
    last_status.state == 3
  end
  
  def override_inactive?
    last_status.state == 4
  end
  
  def fsm_activate
    case last_status.state
      when 0  # de inactivo a activo override
        activate_override
      when 2 # de inactivo override a activo
        activate_override
      else
        [1,'Estado Inconsistente']
    end
  end

  def fsm_deactivate
    case last_status.state 
      when 1 # de activo a inactivo en override
        deactivate_override
      when 3 # de activo override a inactivo
        deactivate_override
      else
        [1,'Estado Inconsistente']
    end
  end
        
  
  private
  def activate
    perform_toggle(1,0)
  end
  
  def activate_override
    perform_toggle(1,1)
  end
  
  def deactivate
    perform_toggle(0,0)
  end
  
  def deactivate_override
    perform_toggle(0,1)
  end
  
  def perform_toggle(status,override)
    cmd = "dqrSender A #{self.device_id} #{self.id} #{status} #{override}"
    Rails.logger.info "Will Perform #{cmd}"
    result = `#{cmd}`
    exitStatus = $?.exitstatus
    
    Rails.logger.info "Perform Result was: #{result}"
    # force device report status
    cmd = "dqrSender S #{self.device_id}"
    `#{cmd}`
    
    [exitStatus, result]
  end
  
end
