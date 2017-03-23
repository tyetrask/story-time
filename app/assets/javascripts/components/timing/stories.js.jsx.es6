import React from 'react';
import ReactDOM from 'react-dom';

class TimingStories extends React.Component {

  render() {
    return (<div id="stories-container" className="col-xs-4 col-xs-offset-1">
             <TimingMyWork
               myWork={this.props.myWork}
               selectedStory={this.props.selectedStory}
               setSelectedStory={this.props.setSelectedStory}
               areCompletedStoriesVisible={this.props.areCompletedStoriesVisible}
             />
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
