class DeviceModule < ActiveRecord::Base
  belongs_to :device
  belongs_to :module_type
  
  validates :name, length: { maximum: 40 }, uniqueness: true
  
  has_many :sensors, class_name: 'ModuleSensor', dependent: :destroy
  
  has_many :events, class_name:'DeviceEventView', foreign_key: :module_id
  
  def last_event
    self.events.order(ts: :desc).first
  end
  
  scope :pinned, ->{ where(show_in_dashboard:true)}
  
  def build_status
    @last_status ||= events.order(ts: :desc)
  end
  
  def last_status
    if !@last_status.nil?
      @last_status.first
    else
      []
    end
  end
  
  def unknown_state?
    @last_status.nil?
  end
  
  def active?
    [1,3].include?(last_known_status)
  end
  def inactive?
    [0,2].include?(last_known_status)
  end
  
  def override_active?
    last_known_status == 3
  end
  
  def override_inactive?
    last_known_status == 2
  end
  
  def is_overriden?
    last_known_status > 1
  end
  
  def transition_to(state)
    case state
      when 0 then deactivate
      when 1 then activate
      when 2 then deactivate_override
      when 3 then activate_override
    end
  end
  
  def activate
    send_toggle_status(1,0)
  end
  
  def activate_override
    send_toggle_status(1,1)
  end
  
  def deactivate
    send_toggle_status(0,0)
  end
  
  def deactivate_override
    send_toggle_status(0,1)
  end
  
  def save_status_and_mark
    self.previous_state = self.last_known_status
    self.in_schedule = true
    save
  end
  
  def restore_status_and_unmark
    self.previous_state = self.last_known_status
    self.in_schedule = false
    save
  end
  
  private
  # run DqR Sender on OS to perform toggle
  def send_toggle_status(status,override, force_report = true)
    cmd = "dqrSender A #{self.device_id} #{self.id} #{status} #{override}"
    Rails.logger.info "DqRSender Perform #{cmd}"
    result = `#{cmd}`
    exit_status = $?.exitstatus
    
    Rails.logger.info "DqrSender Perform: exit code #{exit_status}, output: #{result}"
    
    # device should report back
    if force_report
      send_status_query
    end
    
    Hash.new exit_code: exit_status, output: result 
  end
  
  # run DqR Sender on OS to query device status
  def send_status_query
    cmd = "dqrSender S #{self.device_id}"
    Rails.logger.info "DqRSender Perform #{cmd}"
    result = `#{cmd}`
    exit_status = $?.exitstatus
    Rails.logger.info "DqrSender Perform: exit code #{exit_status}, output: #{result}"
    Hash.new  exit_code: exit_status, output: result 
  end
  
  def inconsistent_status
    [-1,'Inconsistent Status']
  end
  
  # validate state machine transition
  def fsm_validate(from_state, to_state)
    # if no transition then valid
    return true if from_state == to_state
    # otherwise
    valid_states = case from_state
      # from inactive to active or active override
      when 0 then [1,3]
      # from active to inative or inactive override
      when 1 then [0,2]
      # from inactive override to active or inactive
      when 2 then [0,1]
      # from active override to inactive or active
      when 3 then [0,1]
    end
    # true if transition is allowed, false otherwise
    valid_states.include?(to_state)
  end
  
end
