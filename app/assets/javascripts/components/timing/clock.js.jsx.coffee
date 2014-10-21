###* @jsx React.DOM ###

StoryTime.React.TimingClock = React.createClass
  
  app: ->
    window.StoryTime
  
  render: ->
    `<div id="clock-container" className="col-xs-6">
       <div className="panel panel-primary">
         <div className="panel-heading text-center">Clock</div>
         <div className="list-group"></div>
       </div>
     </div>`
