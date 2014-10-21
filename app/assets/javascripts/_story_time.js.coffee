class StoryTimeApp

  name: 'StoryTime'
  React: {}
  csrf_token: $('meta[name=csrf-token]').attr('content')
  
  constructor: ->
    for componentName of @React
      window[componentName] = @React[componentName] if not window[componentName]?


#if window.StoryTime? and window.StoryTime.React?
#  window.StoryTime = new StoryTimeApp { React: window.StoryTime.React }
#else
#  window.StoryTime = new StoryTimeApp
