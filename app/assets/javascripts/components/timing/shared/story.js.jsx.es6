class TimingSharedStory extends React.Component {

  handleClickedStory() {
    return this.props.setSelectedStory(this.props.story);
  }

  storyStateClass() {
    let baseClass = "list-group-item pivotal-story";
    if (this.props.selectedStory === this.props.story) { baseClass = baseClass + ' active'; }
    if (this.props.story.current_state === 'started') { return `${baseClass} started`; }
    if (this.props.story.current_state === 'delivered') { return `${baseClass} started`; }
    if (this.props.story.current_state === 'finished') { return `${baseClass} started`; }
    if (this.props.story.current_state === 'rejected') { return `${baseClass} started`; }
    if (this.props.story.current_state === 'accepted') { return `${baseClass} accepted`; }
    return baseClass;
  }

  storyDescription() {
    if (this.props.story.current_state === 'accepted') {
      return <p><strike>{this.props.story.name}</strike></p>;
    }
    return <p>{this.props.story.name}</p>;
  }

  render() {
    return (<div className="pt-card pt-elevation-0 pt-interactive" style={{padding: 10}} onClick={this.handleClickedStory.bind(this)}>
            {this.storyDescription()}
           </div>);
  }
}

window.TimingSharedStory = TimingSharedStory;
