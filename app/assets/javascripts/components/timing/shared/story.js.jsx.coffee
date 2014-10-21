###* @jsx React.DOM ###

window.TimingSharedStory = React.createClass
  
  handleClickedStory: ->
    @props.setSelectedStory(@props.story)
  
  stateClass: ->
    base_class = "list-group-item pivotal-story"
    base_class = base_class + ' active' if @props.selected_story is @props.story
    return "#{base_class} started" if @props.story.current_state is 'started'
    return "#{base_class} started" if @props.story.current_state is 'delivered'
    return "#{base_class} started" if @props.story.current_state is 'finished'
    return "#{base_class} started" if @props.story.current_state is 'rejected'
    return "#{base_class} accepted" if @props.story.current_state is 'accepted'
    return base_class
    
  
  render: ->
    `<a className={this.stateClass()} onClick={this.handleClickedStory}>
      <span className='pull-right'><i className='fa fa-clock-o'></i> {this.props.story.estimate}</span>
      <p>{this.props.story.name}</p>
     </a>
    `
