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
    graphRefreshRate: 'graph-refresh-interval'
    graphDivisors: 'graph-interval'
    lastMeasure: '[data-behavior="last-measure"]'
    lastTime: '[data-behavior="last-time"]'
    headContainer: 'head-container'
    yLabels: ['No','Yes']

  buildChart: (chid,container,data)->
    chartDataSeries = []
    sensor_type = data.sensor_type
    dataInterval = Number(Fwk.getByBehavior('settings').data(selectors.graphDivisors))
    # labels for graph, comma separated
    dataYLabels = sensor_type.graph_scale_labels.split(',')
    for d in dataYLabels
      dataYLabels[d] = Number(dataYLabels[d])
    
    for datum in data.events
      chartDataSeries.push { x: Date.parse(datum.ts), y: datum.value }
      true
    
    

    if data.events.length > 0
      Fwk.log 'Events'
      value = data.events[0].value
      if sensor_type.graph_scale_type == 'Binary'
        if value == '1.0'
          value = 'Detected'
        else
          value = 'No'
      container.closest('.column').find(selectors.lastMeasure).text("#{value} #{sensor_type.unit}")
      container.closest('.column').find(selectors.lastTime).text("#{Fwk.formatDate(new Date(data.events[0].ts),'%H:%N')} hs")
    
    container.closest('.column').find('.tooltip small').text(sensor_type.graph_description)
    
    
    cssClass = ".#{chid}"
    
    chartData =
      series: [ 
                { name:'', data: chartDataSeries }
              ]
              
    # options for y axis when data is binary
    axisYOptions = {}
    if sensor_type.graph_scale_type == 'Binary'
      axisYOptions.onlyInteger = true
      axisYOptions.labelInterpolationFnc = (value, index)->
          return selectors.yLabels[index]
      axisYOptions.stretch = true
    else if sensor_type.graph_scale_type == 'Auto'
      axisYOptions.type = Chartist.AutoScaleAxis
    else
      axisYOptions.type = Chartist.FixedScaleAxis
      axisYOptions.high = Number(sensor_type.graph_max_value)
      axisYOptions.low = Number(sensor_type.graph_min_value)
      axisYOptions.divisor = Number(sensor_type.graph_step)
        
    options =
      axisX:
        type: Chartist.FixedScaleAxis
        divisor: dataInterval
        labelInterpolationFnc: (value, index, chart) ->
          Fwk.formatDate(new Date(value),'%H:%N')
      axisY: axisYOptions
      lineSmooth: if data.isBinary == true then Chartist.Interpolation.step() else Chartist.Interpolation.simple({ divisor: 2, fillHoles: false })
      showArea: data.isBinary == false
      showPoint: false
      plugins: [ Chartist.plugins.ctAxisTitle(
                  axisX:
                    axisTitle: 'Time'
                    axisClass: 'ct-axis-title'
                    offset:
                      x: 0
                      y: 50
                    textAnchor: 'middle'
                  axisY:
                    axisTitle: sensor_type.unit
                    axisClass: 'ct-axis-title'
                    offset:
                      x: 0
                      y: -1
                    flipTitle: false)]
    
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

  buildChart2:(chid,container,data)->
    # data series container
    dataSeries = []
    labelSeries = []
    mixedSeries = []
    # remap data to typed data
    for datum in data.events
      dataSeries.push Number(datum.value)
      labelSeries.push Date.parse(datum.ts)
      mixedSeries.push { x: new Date(Date.parse(datum.ts)), y: Number(datum.value) }
      true
    
    # y axis labels
    array = data.labels.split ':'
    interval = array[0].split(';')
    step_size = array[1]

    myChart = new Chart(container,
      type: 'line'
      data:
        labels: labelSeries
        datasets: [ {
          label: data.unit
          data: dataSeries
          'backgroundColor': 'rgba(11, 117, 66, 0.4)'
          'borderColor': 'rgba(11, 117, 66, 0.8)'
          pointBorderWidth: 0.5
          radius:2
          lineTension: 0
          borderWidth:2
        } ]
      options:
        legend:
          display: true
        scales: 
          yAxes: [ { ticks: { min: Number(interval[0]), max: Number(interval[1]) } } ]
          xAxes: [ type:'time', time: { unit: 'minute', tooltipFormat: 'h:mm:ss a' } ]
                                )
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
          Fwk.clearMessages()
          App.Device.buildChart chid, container, data
          
        error: ->
          Fwk.showMessage 'negative',true,'Graph Update','Update operation failed'
          
        complete: ->
          #App.Device.setUpdateErrorVisibility(false)
      true
      
    refreshInterval = Fwk.getByBehavior('settings').data(selectors.graphRefreshRate)
      
    Fwk.setTimeout Number(refreshInterval) * 1000, App.Device.updateGraphs

  updateButtons: (selector, eventData, action) ->
    if selector.data('behavior').search('off') > 0 
      button = selectors.toggleOn 
    else 
      button = selectors.toggleOff
    
    if eventData.exit_code == 0 && eventData.output != '1\n'
      selector.addClass('disabled').removeClass('loading')
      selector.siblings(button).removeClass('disabled')
    else
      selector.removeClass('disabled loading')
      Fwk.showMessage 'negative', true, 'Toggle Device Status', 'Toggle operation failed, make sure device is powered on and retry'
      
      
  bindAjax: ->
    
    Fwk.getByBehavior(selectors.commandPalette).on 'ajax:beforeSend', selectors.toggleButton, (event,data,status,xhr)->
      Fwk.get(this).addClass('disabled loading')
    
    Fwk.getByBehavior(selectors.commandPalette).on 'ajax:success', selectors.toggleButton, (event,data,status,xhr)->
      App.Device.updateButtons Fwk.get(this), data
    
    Fwk.getByBehavior(selectors.commandPalette).on 'ajax:error', selectors.toggleButton, (event,data,status,xhr)->
      App.Device.updateButtons Fwk.get(this), data
    
      
  detectData: ->
    device_id = Fwk.getByBehavior(selectors.headContainer).data('device-id')
    $.ajax
      type: "GET"
      dataType: "json"
      url: "/devices/#{device_id}/has_data"
      success: (data)->
        if data.detection_status == 'ok'
          window.location.replace = data.goto
        else
          Fwk.setTimeout 30000, App.Device.detectData
        
      error: ->
        Fwk.showMessage 'negative',true,'Detect ','Device could not be detected'
        
      complete: ->
        #App.Device.setUpdateErrorVisibility(false)
    
    
    
  
  init: ->
    App.Device.updateGraphs()
    App.Device.bindAjax()
    
    
    
    
Fwk.onLoadPage App.Device.init,'devices','show'
Fwk.onLoadPage App.Device.detectData,'devices','detect'