class TimingMyWork extends React.Component {

  render() {
    let stories = this.props.myWork.map((story_object => {
      return (<TimingSharedStory
              key={story_object.id}
              story={story_object}
              selectedStory={this.props.selectedStory}
              setSelectedStory={this.props.setSelectedStory}
              areCompletedStoriesVisible={this.props.areCompletedStoriesVisible}
              />);
      }));
    return (<div className="panel panel-default">
             <div className="panel-heading text-center"><strong>My Work</strong></div>
             <div id="my-work-story-list" className="list-group">
               {stories}
             </div>
           </div>);
  }
}

window.TimingMyWork = TimingMyWork;
