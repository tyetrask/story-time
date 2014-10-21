###* @jsx React.DOM ###

window.TimingStories = React.createClass
  
  render: ->
    `<div id="stories-container" className="col-xs-4 col-xs-offset-1">
       <TimingMyWork my_work={this.props.my_work} />
       <TimingUpcoming />
     </div>`
