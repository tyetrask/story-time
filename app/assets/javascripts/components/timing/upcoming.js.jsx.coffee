###* @jsx React.DOM ###

window.TimingUpcoming = React.createClass
  
  render: ->
    _this = @
    stories = []
    @props.upcoming.map (story_object) ->
      stories.push `<TimingSharedStory key={story_object.id} story={story_object} selected_story={_this.props.selected_story} setSelectedStory={_this.props.setSelectedStory} completed_stories_visible={_this.props.completed_stories_visible} />`
    `<div className="panel panel-default">
       <div className="panel-heading text-center"><strong>Upcoming</strong></div>
       <div id="upcoming-story-list" className="list-group">
         {stories}
       </div>
     </div>`
