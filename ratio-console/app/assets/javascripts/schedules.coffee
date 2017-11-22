# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
App.Schedules = do ->
  
  selectors =
    form: '#new_schedule_day'
    ajaxError: 'ajax:error'
    ajaxSuccess: 'ajax:success'
    submit:'ajax:beforeSend'
    reset:'reset'
    days: ['Mon','Tue','Wed','Thu','Fri','Sat','Sun']
    schedId: '#schedule_day_schedule_id'
    timeline: '.timeline'
    timelineEvent: '.timeline .event'
    timelineEventSelected: '.timeline .event.selected'
    timelineMark: '.timeline .mark'
    eventDetail: 'event-detail'
    eventContent: 'event-content'
    event:'.event'
    deleteEvent: '[data-behavior="delete-event"]'
    closeEvent: '[data-behavior="close-detail"]'
    statusCheck: 'input[type="checkbox"][name="status"]'
    includeCheck: 'input[type="checkbox"][name="include"]'
    scheduleId: 'input[name="schedule_day[schedule_id]"]'
    modulesContent: 'modules-content'
    
  toggleSelection: (schedule)->
    if schedule?
      isSelected = schedule.hasClass('selected')
      eventId = schedule.data('event=id')
    else
      isSelected = true
      
    dimmer = Fwk.getByBehavior(selectors.eventDetail)
    
    Fwk.get(selectors.timelineEvent).removeClass('selected')
    if !isSelected
      schedule.addClass('selected')
      Fwk.getByBehavior(selectors.eventContent).text(schedule.data('text'))
      dimmer.dimmer('show')
    else
      dimmer.dimmer('hide dimmer')
      if dimmer.dimmer('is active')
        dimmer.dimmer('show')
        dimmer.dimmer('hide')
  
  saveDeviceStatus: (toggle)->
    
   
    deviceRow = toggle.closest('tr')
    module_id = deviceRow.data('module-id')
    schedule_id = Fwk.get(selectors.scheduleId).val()
    
    status = deviceRow.find(selectors.statusCheck)
    status_value = status.prop('checked')
    
    include = deviceRow.find(selectors.includeCheck)
    include_value = include.prop('checked')
    
    schedule_module_id = deviceRow.data('schedule-module-id') || 0

    parameters =
      'utf8': '✓'
      'authenticity_token': Fwk.get('meta[name="csrf-token"]').attr('content')
      'schedule_module[device_module_id]': module_id, 
      'schedule_module[desired_status]': if status_value then 1 else 0
      'id': schedule_module_id
      'schedule_id': schedule_id
      'commit': 'Create ScheduleModule'
       
    url = ''
    action = ''
    if schedule_module_id > 0 && !include_value
      # delete
      url = "/schedule_modules/#{schedule_module_id}"
      action = 'DELETE'
    else if schedule_module_id > 0 && include_value
      # update
      url = "/schedule_modules/#{schedule_module_id}"
      action = 'PUT'
    else
      # create
      url = '/schedule_modules'
      action = 'POST'
       
    Fwk.log 'ran'
    $.ajax
      type: action
      dataType: "json"
      url: url
      data: parameters
      success: (data)->
        if action == 'DELETE' && data.status == 'OK'
          deviceRow.data('schedule-module-id',0)
          Fwk.showMessage 'positive',true, 'Include Module', 'Module successfully included', true
        else if data.status == 'OK'
          deviceRow.data('schedule-module-id',data.schedule_module_id)
          Fwk.showMessage 'positive',true, 'Include Module', 'Module successfully included', true
        else
          Fwk.showMessage 'negative',true,'Include Module',data.error
          include.prop('checked', false)
        
      error: (xhr,status)->
        message = ''
        d = JSON.parse(xhr.responseText)
        for k,v of d
          message += v + '\r\n'
          
        Fwk.showMessage 'negative',true, 'Add Schedule', message, true
        include.prop('checked', false)
        
      complete: ->
        
    true
      
    
      
  deleteEvent: ->
    selectedEvent = Fwk.get(selectors.timelineEventSelected)
    eventId = selectedEvent.data('eventId')
    $.ajax
      type: "DELETE"
      dataType: "json"
      url: "/schedule_days/#{eventId}"
      success: (data)->
        Fwk.log 'Removed'
        App.Schedules.toggleSelection()
        selectedEvent.remove()
        
      error: ->
        Fwk.showMessage 'negative',true,'Delete Schedule','Delete operation failed'
        
      complete: ->
        
    true
  
  getPosition: (start, end) ->
    initMinutes = Number(start.substring(0,2)) * 60 + Number(start.substring(3))
    endMinutes = Number(end.substring(0,2)) * 60 + Number(end.substring(3))
    minutes = endMinutes - initMinutes
    width = Fwk.round(minutes * 100 / 1500,2)
    left = Fwk.round(initMinutes * 100 / 1500,2)
    { left: left, width: width }
  
  getMarkPosition: (minutes) ->
    minutes * 60 * 100 / 1500
  
  updateTimeTable: (events) ->
    container = Fwk.get(selectors.timeline)
    container.empty().append(events.html)
    @initTimeline()
    lastEvent = Fwk.getByData('event-id',events.lastId)
    lastEvent.transition('jiggle')
    Fwk.log 'timetable Updated'
    
  initTimeline: ->
    Fwk.get(selectors.timelineMark).each ->
      mark = Fwk.get(this)
      hour = App.Schedules.getMarkPosition(mark.data('mark'))
      mark.css('left', hour + 4 + '%')
      mark.css('width', '4%')
      true
      
    Fwk.get(selectors.timelineEvent).each ->
      schedule = Fwk.get(this)
      props = App.Schedules.getPosition(schedule.data('span-start'),schedule.data('span-end'))
      schedule.width(props.width + '%')
      schedule.css('left',props.left + 4 + '%')
      true
  init: ->
    
    Fwk.get(selectors.form)
      .on selectors.submit, ->
        Fwk.clearMessages()
    
      .on selectors.ajaxSuccess, (xhr,data,status) ->
        App.Schedules.updateTimeTable(data)
      
      .on selectors.ajaxError, (xhr,data,status)->
        message = ''
        d = JSON.parse(data.responseText)
        for k,v of d
          message += v + '\r\n'
          
        Fwk.showMessage 'negative',true, 'Add Schedule', message, true
      
      .on selectors.reset, ->
        Fwk.clearMessages()
        Fwk.get('select').dropdown('restore defaults')
        
      
    timeline = Fwk.get(selectors.timeline)
    timeline.on 'click', selectors.event, ->
        App.Schedules.toggleSelection(Fwk.get(this))
    
    timeline.on 'click', selectors.deleteEvent, ->
        App.Schedules.deleteEvent()
    
    timeline.on 'click', selectors.closeEvent, ->
        App.Schedules.toggleSelection()
      
    App.Schedules.initTimeline()
    
    Fwk.getByBehavior(selectors.modulesContent).on 'click', 'input', ->
      App.Schedules.saveDeviceStatus(Fwk.get(this))
    
Fwk.onLoadPage App.Schedules.init,'schedules','show'