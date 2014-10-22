$ ->
  $(document)
    .ajaxStop((->
      $('#loading-indicator').removeClass('la-animate')
      ).bind(@))
    .ajaxStart((->
      $('#loading-indicator').addClass('la-animate')
      ).bind(@))
