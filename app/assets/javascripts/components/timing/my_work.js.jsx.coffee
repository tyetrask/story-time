###* @jsx React.DOM ###

window.TimingMyWork = React.createClass
  
  render: ->
    _this = @
    stories = []
    @props.my_work.map (story_object) ->
      stories.push `<TimingSharedStory key={story_object.id} story={story_object} selected_story={_this.props.selected_story} setSelectedStory={_this.props.setSelectedStory} />`
    `<div className="panel panel-default">
       <div className="panel-heading text-center"><strong>My Work</strong></div>
       <div id="my-work-story-list" className="list-group">
         {stories}
       </div>
     </div>`
