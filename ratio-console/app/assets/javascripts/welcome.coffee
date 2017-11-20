# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
App.Welcome = do ->

  selectors =
    sensorGraph: 'sensor-graph'
    commandPalette: 'command-palette'
    toggleButton: '[data-behavior*="toggle"]'
    toggleOn: '[data-behavior*="toggle-on"]'
    toggleOff: '[data-behavior*="toggle-off"]'
    graphRefreshRate: 'graph-refresh-interval'
    graphDivisors: 'graph-interval'
    lastMeasure: '[data-behavior="last-measure"]'
    headContainer: 'head-container'
    yLabels: ['No','Yes']

  updateButtons: (selector, eventData, action) ->
    if selector.data('behavior').search('off') > 0 
      button = selectors.toggleOn 
    else 
      button = selectors.toggleOff
    
    if eventData.status.exit_code == '0'
      selector.addClass('disabled').removeClass('loading')
      selector.siblings(button).removeClass('disabled')
    else
      selector.removeClass('disabled loading')
      Fwk.showMessage 'negative', true, 'Toggle Device Status', 'Toggle operation failed, make sure device is powered on and retry'
      
      
  bindAjax: ->
    Fwk.log 'binding ajax'
    Fwk.getByBehavior(selectors.commandPalette).on 'ajax:beforeSend', selectors.toggleButton, (event,data,status,xhr)->
      Fwk.get(this).addClass('disabled loading')
    
    Fwk.getByBehavior(selectors.commandPalette).on 'ajax:success', selectors.toggleButton, (event,data,status,xhr)->
      App.Welcome.updateButtons Fwk.get(this), data
    
    Fwk.getByBehavior(selectors.commandPalette).on 'ajax:error', selectors.toggleButton, (event,data,status,xhr)->
      App.Welcome.updateButtons Fwk.get(this), data
    

Fwk.onLoadPage App.Welcome.bindAjax,'welcome','index'