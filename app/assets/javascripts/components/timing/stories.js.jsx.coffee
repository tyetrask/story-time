###* @jsx React.DOM ###

window.TimingStories = React.createClass
  
  render: ->
    `<div id="stories-container" className="col-xs-4 col-xs-offset-1">
       <TimingMyWork my_work={this.props.my_work} selected_story={this.props.selected_story} setSelectedStory={this.props.setSelectedStory} completed_stories_visible={this.props.completed_stories_visible} />
       <TimingUpcoming upcoming={this.props.upcoming} epic_list={this.props.epic_list} selected_story={this.props.selected_story} setSelectedStory={this.props.setSelectedStory} completed_stories_visible={this.props.completed_stories_visible} />
     </div>`
