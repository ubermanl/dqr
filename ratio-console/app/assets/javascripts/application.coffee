# -------------------------------------------
# JAVASCRIPT DE LA APLICACION
# aqui solo van los requires no hay que poner
# codigo
# -------------------------------------------
#= require jquery
#= require jquery.turbolinks
#= require jquery_ujs
#= require semantic-ui
#= require turbolinks
#= require chartist
#= require framework
#= require global
#= require_tree .

# unica linea que inicia la aplicacion
$(document).on 'turbolinks:load', ->
  App.init()