###* @jsx React.DOM ###

StoryTime.React.TimingUpcoming = React.createClass
  
  app: ->
    window.StoryTime
  
  render: ->
    `<div className="panel panel-default">
       <div className="panel-heading text-center"><strong>Upcoming</strong></div>
       <div id="upcoming-story-list" className="list-group"></div>
     </div>`
