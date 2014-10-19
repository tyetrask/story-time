class StoryTimeApp

  name: 'StoryTime'
  csrf_token: $('meta[name=csrf-token]').attr('content')
  
  constructor: ->
    $('body')

window.StoryTime = new StoryTimeApp
