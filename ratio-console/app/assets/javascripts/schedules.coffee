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
    
  
  updateTimeTable: ->
    table = new Timetable()
    renderer = new Timetable.Renderer(table)
    renderer.draw('.timetable')

  init: ->
    
    Fwk.get(selectors.form)
      .on selectors.submit, ->
        Fwk.clearMessages()
    
      #.on selectors.ajaxSuccess, (xhr,data,status) ->
        # somethind
      
      .on selectors.ajaxError, (xhr,data,status)->
        message = ''
        d = JSON.parse(data.responseText)
        for k,v of d
          message += v + '\r\n'
          
        Fwk.showMessage 'negative',true, 'Add Schedule', message, true
      
      .on selectors.reset, ->
        Fwk.clearMessages()
        Fwk.get('select').dropdown('restore defaults')
    
Fwk.onLoadPage App.Schedules.init,'schedules','show'