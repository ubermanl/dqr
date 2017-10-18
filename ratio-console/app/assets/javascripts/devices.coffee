# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
App.Device = do ->
  
  selectors =
    sensorGraph: 'sensor-graph'
    commandPalette: 'command-palette'
    toggleButton: '[data-behavior*="toggle"]'
    toggleOn: '[data-behavior*="toggle-on"]'
    toggleOff: '[data-behavior*="toggle-off"]'

  buildChart: (chid,container,data)->
    
    chartDataSeries = []
    
    Fwk.log data.isBinary
    
    for datum in data.events
      chartDataSeries.push { x: Date.parse(datum.ts), y: datum.value }
      true
    
    cssClass = ".#{chid}"
    
    chartData =
      series: [ 
                { name:'', data: chartDataSeries }
              ]
    
    options =
      axisX:
        type: Chartist.FixedScaleAxis
        divisor: 10
        labelInterpolationFnc: (value, index, chart) ->
          Fwk.formatDate(new Date(value),'%H:%N')
      axisY:
        type: Chartist.AutoScaleAxis
      lineSmooth: if data.isBinary == true then Chartist.Interpolation.step() else Chartist.Interpolation.simple({ divisor: 2, fillHoles: false })
      showArea: data.isBinary == false
      showPoint: false

    chart = new Chartist.Line cssClass, chartData, options

    chart.on 'draw', (data) ->
      if data.type == 'line' or data.type == 'area'
        data.element.animate d:
          begin: data.index
          dur: 2000
          from: data.path.clone().translate(data.chartRect.width() * 0.05, 0).stringify()
          to: data.path.clone().stringify()
          easing: Chartist.Svg.Easing.easeOutQuint
      return

                              
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
      
    Fwk.setTimeout 60000, App.Device.updateGraphs

  updateButtons: (selector, eventData, action) ->
    if selector.data('behavior').search('off') > 0 
      button = selectors.toggleOn 
    else 
      button = selectors.toggleOff
    
    if eventData.status == 0
      selector.addClass('disabled').removeClass('loading')
      selector.siblings(button).removeClass('disabled')
    else
      selector.removeClass('disabled loading')
      alert('El dispositivo no esta respondiendo, o bien aun no ha reportado su estado')
      
  bindAjax: ->
    
    Fwk.getByBehavior(selectors.commandPalette).on 'ajax:beforeSend', selectors.toggleButton, (event,data,status,xhr)->
      Fwk.get(this).addClass('disabled loading')
    
    Fwk.getByBehavior(selectors.commandPalette).on 'ajax:success', selectors.toggleButton, (event,data,status,xhr)->
      App.Device.updateButtons Fwk.get(this), data
    
    Fwk.getByBehavior(selectors.commandPalette).on 'ajax:error', selectors.toggleButton, (event,data,status,xhr)->
      App.Device.updateButtons Fwk.get(this), data
    
      
  init: ->
    App.Device.updateGraphs()
    App.Device.bindAjax()
    
    
    
    
Fwk.onLoadPage App.Device.init,'devices','show'
