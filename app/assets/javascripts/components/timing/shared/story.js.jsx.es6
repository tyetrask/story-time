import React from 'react';
import ReactDOM from 'react-dom';

class TimingSharedStory extends React.Component {

  constructor() {
    super()
  }

  handleClickedStory() {
    return this.props.setSelectedStory(this.props.story);
  }

  storyStateClass() {
    let baseClass = "list-group-item pivotal-story";
    if (this.props.selectedStory === this.props.story) { baseClass = baseClass + ' active'; }
    if ((this.props.story.current_state === 'accepted') && !this.props.areCompletedStoriesVisible) { baseClass = baseClass + ' hidden'; }
    if (this.props.story.current_state === 'started') { return `${baseClass} started`; }
    if (this.props.story.current_state === 'delivered') { return `${baseClass} started`; }
    if (this.props.story.current_state === 'finished') { return `${baseClass} started`; }
    if (this.props.story.current_state === 'rejected') { return `${baseClass} started`; }
    if (this.props.story.current_state === 'accepted') { return `${baseClass} accepted`; }
    return baseClass;
  }


  render() {
    let labels = [];
    return (<a className={this.storyStateClass()} onClick={this.handleClickedStory.bind(this)}>
            <span className='pull-right'><i className='fa fa-clock-o'></i> {this.props.story.estimate}</span>
            <p>{this.props.story.name}</p>
           </a>);
  }
}

window.TimingSharedStory = TimingSharedStory;
