$(function() {
  let loadingIndicator = $('#loading-indicator');
  return $(document)
    .ajaxStop((() => {
      return loadingIndicator.removeClass('la-animate');
      }))
    .ajaxStart((() => {
      return loadingIndicator.addClass('la-animate');
      }));
});
