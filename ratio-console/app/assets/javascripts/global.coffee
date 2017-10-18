window.App = do ->
  
  # selectores para no repetir texto
  # en el javascript
  selectors =
    sidebarMenu: '.ui.sidebar'
    sidebarMenuButton: 'sidebar-toggle'
    sidebarContext: '.bottom.segment'
    messageSelector: '.message .close'
    
    
  toggleSidebar = ->
    $(selectors.sidebarMenu).sidebar('toggle')
    
  # inicializacion de la aplicacion
  init : ->
    # log de inicio de aplicacion
    Fwk.log 'Application Init'
    
    # inicializa el sidebar        
    Fwk.get(selectors.sidebarMenu).sidebar({ context: $(selectors.sidebarContext)})

    # attach del toggle del menu
    Fwk.getByBehavior(selectors.sidebarMenuButton).on 'click', ->
      #log de la accion
      Fwk.log 'Sidebar Toggle'
      # muestra el sidebar
      toggleSidebar()
   
    #d dismissable messages
    Fwk.get(selectors.messageSelector).on 'click', ->
      Fwk.get(this)
        .closest('.message')
        .transition('fade')
  