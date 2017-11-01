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
    
  
  updateTimeTable: (events) ->
    table = new Timetable()
    
    table.setScope(0,23);
    
    if events.everyday_day 
      table.addLocations(['Everyday'])
    else
      table.addLocations(selectors.days)
    

    
    for k,v of events.schedule_days
      start_date = new Date
      end_date = new Date
      start_date.setHours v.start_hour.substring(0,2)
      start_date.setMinutes v.start_hour.substring(3)
      start_date.setSeconds 0
      end_date.setHours v.end_hour.substring(0,2)
      end_date.setMinutes v.end_hour.substring(3)
      end_date.setSeconds 0
      table.addEvent 'On', App.Schedules.translateDay(v.day), start_date,end_date

    renderer = new Timetable.Renderer(table)
    renderer.draw('.timetable')

  translateDay: (d,is_everyday_schedule)->
    if d == 0 || is_everyday_schedule 
      'Everyday'
    else
      selectors.days[d]

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
    
    sched_id = Fwk.get(selectors.schedId).val()
    
    $.ajax
      type: "GET"
      dataType: "json"
      url: "/schedules/#{sched_id}/schedules"
      success: (data)->
        App.Schedules.updateTimeTable data
        
      error: ->
        Fwk.showMessage 'negative',true,'Time Table Update','Update operation failed'
        
      complete: ->
        #App.Device.setUpdateErrorVisibility(false)
    
    
    
Fwk.onLoadPage App.Schedules.init,'schedules','show'