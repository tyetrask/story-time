class TimingMyWork extends React.Component {

  render() {
    let stories = this.props.myWork.map((story => {
      return (<TimingSharedStory
              key={story.id}
              story={story}
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
