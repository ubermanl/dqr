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
    last_status.state == 1
  end
  def inactive?
    last_status.state == 0
  end
  
  def override_active?
    last_status.state == 3
  end
  
  def override_inactive?
    last_status.state == 4
  end
  
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
  
  private
  def perform_toggle(status,override)
    cmd = "dqrSender A #{self.device_id} #{self.id} #{status} #{override}"
    Rails.logger.info cmd
    result = `#{cmd}`
    Rails.logger.info result
    result
  end
  
end
