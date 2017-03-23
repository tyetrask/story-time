import React from 'react';
import ReactDOM from 'react-dom';

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
    return (<div>
             <div className="pt-callout">
               <h5>My Work</h5>
             </div>
             <div id="my-work-story-list">
               {stories}
             </div>
           </div>);
  }

}

window.TimingMyWork = TimingMyWork;
