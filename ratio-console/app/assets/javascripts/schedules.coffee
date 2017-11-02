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
    timelineMark: '.timeline .mark'
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
    
  initTimeline: ->
    Fwk.get(selectors.timelineMark).each ->
      mark = Fwk.get(this)
      hour = App.Schedules.getMarkPosition(mark.data('mark'))
      mark.css('left', hour + 4 + '%')
      mark.css('width', '4%')
      true
      
    Fwk.get(selectors.timelineEvent).each ->
      event = Fwk.get(this)
      props = App.Schedules.getPosition(event.data('span-start'),event.data('span-end'))
      console.log props
      event.width(props.width + '%')
      event.css('left',props.left + 4 + '%')
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
    
    App.Schedules.initTimeline()
    
Fwk.onLoadPage App.Schedules.init,'schedules','show'