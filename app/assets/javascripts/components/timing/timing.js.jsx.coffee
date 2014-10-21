###* @jsx React.DOM ###

StoryTime.React.Timing = React.createClass
  
  app: ->
    window.StoryTime
  
  render: ->
    `<div>
      <TimingStories />
      <TimingClock />
     </div>`
