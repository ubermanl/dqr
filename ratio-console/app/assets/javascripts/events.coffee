# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
window.App.Events = do ->
  
  selectors = 
    container: 'events-table'
    lastRow: '> tbody > tr:last-of-type td:eq(0)'
    loadMoreButton:'load-more'
    
  loadMoreContent: ->
    #obtener la instancia del boton
    loadMoreContentButton = Fwk.getByIdentifier('load-more')
    # desactiva
    loadMoreContentButton.addClass('loading disabled')
    # obtiene el container
    container = Fwk.getByIdentifier(selectors.container)
    # determina el ultimo evento cargado
    lastEventId = container.find(selectors.lastRow).text()
    # referencia al body
    tableBody = container.find('> tbody')
    $.ajax
      type: "GET"
      dataType: "json"
      url: "/events.json?last_event_id=" + lastEventId
      success: (data)->
        for r in data.rows
          tableBody.append(r.row)
          true
      error: ->
        alert('Error al obtener datos')
      complete: ->
        loadMoreContentButton.removeClass('disabled')
        
  init: ->
    Fwk.attachClick 'load-more', App.Events.loadMoreContent

# registra en el page load
Fwk.onLoadPage App.Events.init, 'events','index'