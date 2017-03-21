window.TimingMyWork = React.createClass

  render: ->
    stories = []
    @props.my_work.map(((story_object) ->
      stories.push `<TimingSharedStory
                    key={story_object.id}
                    story={story_object}
                    selected_story={this.props.selected_story}
                    setSelectedStory={this.props.setSelectedStory}
                    completed_stories_visible={this.props.completed_stories_visible}
                    />`
      ).bind(@))
    `<div className="panel panel-default">
       <div className="panel-heading text-center"><strong>My Work</strong></div>
       <div id="my-work-story-list" className="list-group">
         {stories}
       </div>
     </div>`
