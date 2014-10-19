class Timing
  
  constructor: ->
    _this = @
    console.log 'beep'
    $('a.pivotal-story').click (e) ->
      _this.focusOnPivotalStory($(@))
  
  
  toggleDoneStoryVisibility: (clicked_button) ->
    console.log clicked_button
  
  
  clearAllStoryFocus: ->
    $('a.pivotal-story').removeClass('active')
  
  
  focusOnPivotalStory: (clicked_story) ->
    @clearAllStoryFocus()
    clicked_story.addClass('active')
  
  


$ ->
  if $('#clock-container').length > 0
    StoryTime.timing = new Timing
