import React from 'react';
import ReactDOM from 'react-dom';

class TimingStories extends React.Component {

  render() {
    const viewingMyWork = false;
    if (viewingMyWork) {
      return (<div id="stories-container">
               <TimingMyWork
                 myWork={this.props.myWork}
                 selectedStory={this.props.selectedStory}
                 setSelectedStory={this.props.setSelectedStory}
                 areCompletedStoriesVisible={this.props.areCompletedStoriesVisible}
               />
             </div>);
    }
    return (<div id="stories-container">
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
