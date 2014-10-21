###* @jsx React.DOM ###

window.TimingStories = React.createClass
  
  render: ->
    `<div id="stories-container" className="col-xs-4 col-xs-offset-1">
       <TimingMyWork my_work={this.props.my_work} selected_story={this.props.selected_story} setSelectedStory={this.props.setSelectedStory} />
       <TimingUpcoming upcoming={this.props.upcoming} selected_story={this.props.selected_story} setSelectedStory={this.props.setSelectedStory} />
     </div>`
