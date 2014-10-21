###* @jsx React.DOM ###

StoryTime.React.TimingStories = React.createClass
  
  app: ->
    window.StoryTime
  
  render: ->
    `<div id="stories-container" className="col-xs-4 col-xs-offset-1">
       <TimingMyWork />
       <TimingUpcoming />
     </div>`
