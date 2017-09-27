class Fwk

  settings =
    # activa o desactiva el log de eventos
    debug: true
    # nivel de logueo de eventos: warn | debug | trace
    # 1 debug
    # 2 warn
    logLevel: 1
    dayNamesLong: ['domingo', 'lunes', 'martes', 'miércoles', 'jueves', 'viernes', 'sabado']
    dayNamesShort: ['dom', 'lun', 'mar', 'mié', 'jue', 'vie', 'sa']
    monthNamesLong: ['enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio', 'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre']
    monthNamesShort: ['ene', 'feb', 'mar', 'abr', 'may', 'jun', 'jul', 'ago', 'sep', 'oct', 'novi', 'dic']

  formatDateFunctions = 
    d: (d)-> d.getDate().toString()
    D: (d)-> 
      day = d.getDate()
      if day < 10
        '0' + day.toString()
      else
        day.toString
    m: (d)-> (d.getMonth() + 1).toString()
    M: (d)-> 
      month = d.getMonth() + 1
      if month < 10
        '0' + month.toString()
      else
        month.toString()
    y: (d)-> d.getFullYear().toString().substring(2,2)
    Y: (d)-> d.getFullYear().toString()
    w: (d)-> settings.dayNamesShort[d.getDay()]
    W: (d)-> settings.dayNamesShort[d.getDay()]
    h: (d)->
      hours = d.getHours()
      if hours > 12
        hours - 12
      else
        hours
    H: (d)-> d.getHours().toString()
    n: (d)-> d.getMinutes().toString()
    N: (d)-> 
      minute = d.getMinutes()
      if minute < 10
        '0' + minute.toString()
      else
        minute.toString()
    s: (d)-> d.getSeconds().toString()
    S: (d)-> 
      second = d.getSeconds()
      if second < 10
        '0' + second.toString()
      else
        second.toString()
    l: (d)-> d.getMilliseconds().toString()
    L: (d)-> 
      milis = d.getMilliseconds()
      if milis < 10
        '00' + milis.toString()
      else if milis < 100
        '0' + milis.toString()
      else
        milis.toString()
    p: (d)->
      hours = d.getHours()
      if hours >= 12
        'pm'
      else
        'am'
    P: (d)->
      hours = d.getHours()
      if hours >= 12
        'PM'
      else
        'AM'

  # constructor de la clase
  constructor: ->

  Fwk::getObject = ->
    formatDateFunctions

  # devuelve un timestamp numerico
  Fwk::getTimeStamp = ->
    return new Date().getTime()
  
  Fwk::padLeft = (string,length,char)->
    padLength = length - string.length + 1
    if padLength > 0
      Array(padLength).join(char||'0')+string
    else
      string
  
  Fwk::padRight = (string, length, char) ->
    padLength = length - string.length + 1
    if padLength > 0
      string+Array(padLength).join(char||'0')
    else
      string
  
  Fwk::toProperCase = (string)->
    string.toLowerCase().replace(/^(.)|\s(.)/g, (match)-> match.toUpperCase())
  
  Fwk::replaceAll = (string,search,replacement)->
    string.replace(new RegExp(search,'g'),replacement)
  
  
  Fwk::interpolate = (string, placeholders)->
    if typeof string == 'undefined'
      return ''
    else
      string.replace /\{\{(\w+)\}\}/g, (m,i)->
        placeholders[m] || '???'
  
  Fwk::mid = (string,start,length)->
    string.substring(start,start+length)
  
  Fwk::right = (string,length)->
    string = this.toString()
    l = string.length - length
    if l > 0
      string.substring(l)
    else
      string
  
  Fwk::left = (string, length)->
    string = this.toString()
    if string.length - length > 0
      string.substring(0,length)
    else
      string
      
  Fwk::formatString = (string,args...)->
    string.toString().replace /{(\d+)}/g, (m,i)->
      if typeof args[i] != 'undefined'
        args[i]
      else
        m
  Fwk::formatDate = (date, format)->
    format.replace /%([a-zA-Z])/g, (m,i)->
      if typeof formatDateFunctions[i] != 'undefined'
        formatDateFunctions[i](date)
      else
        m

  Fwk::round = (value,decimals)->
    Number Math.round(value+'e'+decimals)+'e-'+decimals

  # escribe una linea en la consola
  Fwk::writeConsoleLine = (messageType,message) ->
    console.log  "#{@getTimeStamp()} #{messageType}: #{message}"
    
  # escribe una linea de log en la consola
  Fwk::log = (message) ->
    if settings.logLevel == 1
      @writeConsoleLine 'log', message
      
  # escribe una linea de warning en la consola
  Fwk::warn = (message) ->
    if settings.logLevel <= 2
      @writeConsoleLine 'warn', message
  
  # obtiene elementos en base al atributo data-behaviour
  Fwk::getByBehavior = (selector) ->
    $("[data-behavior='#{selector}']")
  
  Fwk::getByIdentifier = (selector) ->
    $("[data-identifier='#{selector}']")
  
  Fwk::getByData = (data,selector) ->
    $("[data-#{data}='#{selector}']")
    
  # obtiene un elemento desde jquery
  Fwk::get = (selector) ->
    $(selector)
    
  # devuelve true o false segun si se 
  # encuentra o no en la pagina en cuestion
  Fwk::inPage = (controller, actions...) ->
    # obtiene una referencia al body
    body = @get('body')
    # si no es el controller deseado, directamente retorna false
    return false if body.data('controller') != controller.toLowerCase()
    # retorna false si no es la action deseada
    return false if body.data('action') not in actions
    # en caso contrario retorna true
    return true
    
  Fwk::onLoadPage = (f,controller,actions...) ->
    # log de registro
    @log 'Register onLoadPage Function'
    #
    self = @
    $(document).on 'turbolinks:load', ->
      self.log 'Turbolinks Load'
      # se hace el matching de controller y action
      if self.inPage controller, actions...
        self.log 'Running PageLoad Function for ' + controller + ' controller'
        f()
  
  # attach de una funcion a un elemento con ese comportamiento
  Fwk::attachClick = (behavior, func, container)->
    if container?
      @getByBehavior behavior
        .on 'click',container, func
    else
      @getByBehavior behavior
        .on 'click', func
    
# attach de la instancia de la clase
# a la ventana del navegador
window.Fwk = new Fwk()