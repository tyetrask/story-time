class TimingSharedStory extends React.Component {

  handleClickedStory() {
    if (this.props.selectedStory === this.props.story) {
      return this.props.setSelectedStory(null);
    }
    this.props.setSelectedStory(this.props.story);
  }

  storyStateClass() {
    let baseClass = "story-card pt-card pt-elevation-0 pt-interactive";
    if (this.props.selectedStory === this.props.story) { baseClass = baseClass + ' selected'; }
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

window.TimingSharedStory = TimingSharedStory;
