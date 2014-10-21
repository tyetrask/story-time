###* @jsx React.DOM ###

StoryTime.React.TimingMyWork = React.createClass
  
  app: ->
    window.StoryTime
  
  render: ->
    `<div className="panel panel-default">
       <div className="panel-heading text-center"><strong>My Work</strong></div>
       <div id="my-work-story-list" className="list-group"></div>
     </div>`
