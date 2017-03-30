import React from 'react';
import ReactDOM from 'react-dom';

class StoryListStory extends React.Component {

  handleClickedStory() {
    if (this.props.selectedStoryID === this.props.story.id) {
      return this.props.setSelectedStoryID(null);
    }
    this.props.setSelectedStoryID(this.props.story.id);
  }

  storyStateClass() {
    let baseClass = "story-card pt-card pt-elevation-0 pt-interactive";
    if (this.props.selectedStoryID === this.props.story.id) { baseClass = baseClass + ' selected'; }
    if (this.props.story.current_state === 'started') { return `${baseClass} started`; }
    if (this.props.story.current_state === 'accepted') { return `${baseClass} accepted`; }
    return baseClass;
  }

  storyIcon() {
    if (this.props.story.current_state === 'accepted') {
      return <i className="fa fa-check-square" />
    } else if (this.props.story.current_state === 'started') {
      return <i className="fa fa-circle-o-notch fa-spin" />
    }
    return null;
  }

  render() {
    return (<div className={this.storyStateClass()} style={{padding: 10}} onClick={this.handleClickedStory.bind(this)}>
            {this.storyIcon()} {this.props.story.name}
           </div>);
  }
}

window.StoryListStory = StoryListStory;
