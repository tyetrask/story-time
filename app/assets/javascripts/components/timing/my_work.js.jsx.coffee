###* @jsx React.DOM ###

window.TimingMyWork = React.createClass
  
  render: ->
    stories = []
    @props.my_work.map (story_object) ->
      stories.push `<TimingSharedStory story={story_object} />`
    `<div className="panel panel-default">
       <div className="panel-heading text-center"><strong>My Work</strong></div>
       <div id="my-work-story-list" className="list-group">
         {stories}
       </div>
     </div>`
