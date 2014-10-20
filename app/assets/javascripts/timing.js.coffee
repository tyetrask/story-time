class Timing
  
  constructor: ->
    _this = @
    @setSizeOfStoryContainer()
    @populateProjectsList()
    $('a.pivotal-story').click (e) ->
      _this.focusOnPivotalStory($(@))
    $('#control-panel-toggle a').click (e) ->
      _this.toggleControlPanelVisibility()
  
  
  # Setup Functions
  
  setSizeOfStoryContainer: ->
    window_height = $(window).height()
    navigation_height = $('#navigation-container').height()
    $('#stories-container').css('height', (window_height - navigation_height))
  
  
  populateProjectsList: ->
    [].map (project_object) ->
      $('#project-list').append("<li><a>#{project_object['name']}</a></li>")
  
  
  # Toggle Functions
  
  toggleControlPanelVisibility: ->
    $('#control-panel-container').slideToggle()
    if $('#control-panel-container').is(":visible")
      $('#control-panel-toggle').addClass('active')
    else
      $('#control-panel-toggle').removeClass('active')
  
  
  toggleDoneStoryVisibility: (clicked_button) ->
    console.log clicked_button
  
  
  # Story Control Functions
  
  clearAllStoryFocus: ->
    $('a.pivotal-story').removeClass('active')
  
  
  focusOnPivotalStory: (clicked_story) ->
    @clearAllStoryFocus()
    clicked_story.addClass('active')
  
  


$ ->
  if $('#clock-container').length > 0
    StoryTime.timing = new Timing
