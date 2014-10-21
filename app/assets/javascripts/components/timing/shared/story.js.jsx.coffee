###* @jsx React.DOM ###

window.TimingSharedStory = React.createClass
  
  focusOnStory: ->
    console.log 'doo!'
  
  stateClass: ->
    "list-group-item pivotal-story started"
  
  render: ->
    `<a data-pivotal-story-id={this.props.story.id} class={this.stateClass} onClick={this.focusOnStory}>
      <span class='pull-right'><i class='fa fa-clock-o'></i> {this.props.story.estimate}</span>
      <p>{this.props.story.name}</p>
     </a>
    `
