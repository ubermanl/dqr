window.App = do ->
  
  # selectores para no repetir texto
  # en el javascript
  selectors =
    sidebarMenu: '.ui.sidebar'
    sidebarMenuButton: 'sidebar-toggle'
    sidebarContext: '.bottom.segment'
    messageSelector: '.message .close'
    waitPopup: '#modal-wait'
    
  hideWaitPopup = ->
    modal = Fwk.get(selectors.waitPopup)
    modal.modal({ transition:'fade',duration:250, closable: false }).modal('hide').modal('hide dimmer')
    
  showWaitPopup = ->
    modal = Fwk.get(selectors.waitPopup)
    modal.modal({closable: false, duration:0}).modal('show')
    
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
  
    # init dropdowns
    Fwk.get('select').each ->
      select = $(this)
      isFullTextSearch = select.hasClass('fullTextSearch')
      allowAdd = select.hasClass('allowAdd')
      isDropdown = select.hasClass('is-dd')
      isClearable = select.hasClass('clearable')
      isCompact = select.hasClass('compact')
      clearValue = select.data('clear-value')
      searchable = select.hasClass('searchable')
      
      if isFullTextSearch
        searchType = 'exact'
      else
        searchType = false
      
      if searchable
        select.addClass('ui search')  
      
      select.dropdown
        showOnFocus: !isFullTextSearch
        fullTextSearch: searchType
        selectOnKeydown: false
        allowAdditions: allowAdd
      
      if isCompact
        select.closest('.dropdown').addClass('compact')
        
      if isClearable
        dropdown = select.closest('.dropdown')
        # agrega el boton de remove
        dropdown.find('i.dropdown').after('<i class="remove icon" title="Limpiar"></i>')
        dropdown.find('.remove.icon').on 'click', (e)->
          if clearValue?
            dropdown.dropdown('set selected',clearValue)
          else
            dropdown.dropdown('clear')
          e.stopPropagation()
      true

    Fwk.get('.accordion').accordion()
    
    Fwk.get(document).ajaxStart ->
      showWaitPopup()
    
    Fwk.get(document).ajaxComplete ->
      hideWaitPopup()