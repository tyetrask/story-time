$ ->
  loading_indicator = $('#loading-indicator')
  $(document)
    .ajaxStop((->
      loading_indicator.removeClass('la-animate')
      ).bind(@))
    .ajaxStart((->
      loading_indicator.addClass('la-animate')
      ).bind(@))
