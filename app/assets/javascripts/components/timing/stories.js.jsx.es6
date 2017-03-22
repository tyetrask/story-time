class TimingStories extends React.Component {

  render() {
    const viewingMyWork = false;
    if (viewingMyWork) {
      return (<div id="stories-container" className="col-xs-4 col-xs-offset-1">
               <TimingMyWork
                 myWork={this.props.myWork}
                 selectedStory={this.props.selectedStory}
                 setSelectedStory={this.props.setSelectedStory}
                 areCompletedStoriesVisible={this.props.areCompletedStoriesVisible}
               />
             </div>);
    }
    return (<div id="stories-container" className="col-xs-4 col-xs-offset-1">
             <TimingUpcoming
              upcoming={this.props.upcoming}
              epicList={this.props.epicList}
              selectedStory={this.props.selectedStory}
              setSelectedStory={this.props.setSelectedStory}
              areCompletedStoriesVisible={this.props.areCompletedStoriesVisible}
             />
           </div>);
  }

}

window.TimingStories = TimingStories;
