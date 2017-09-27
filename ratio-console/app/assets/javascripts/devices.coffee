# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
App.Device = do ->
  
  selectors =
    sensorGraph: 'sensor-graph'
  
  buildChart: (chid,container,data)->
    chartData = []
    
    for datum in data.events
      chartData.push { x: Date.parse(datum.ts), y: datum.value }
      true
      
    chart = new Chartist.Line ".#{chid}",
                              series: [
                                { name:'', data: chartData }
                              ],
                              { axisX:
                                  type: Chartist.FixedScaleAxis,
                                  divisor: 15,
                                  labelInterpolationFnc: (value)->
                                    return Fwk.formatDate(new Date(value),'%H:%N')
                              }
                              
                                
                              
      
                
    

  updateGraphs: ->
    Fwk.log selectors
    graphContainers = Fwk.getByData(selectors.sensorGraph,'graph')
    graphContainers.each ->
      
      container = $(this)
      
      mid = container.data('module-id')
      stid = container.data('sensor-type-id')
      sunit = container.data('sensor-unit')
      chid = container.attr('class')
      
      $.ajax
        type: "GET"
        dataType: "json"
        url: "/module_sensors/get_events?device_module_id=#{mid}&sensor_type_id=#{stid}"
        success: (data)->
          App.Device.buildChart chid, container, data
          
        error: ->
          alert('Error al obtener datos')
        complete: ->
      true
      
  init: ->
    App.Device.updateGraphs()    
    
    
Fwk.onLoadPage App.Device.init,'devices','show'
