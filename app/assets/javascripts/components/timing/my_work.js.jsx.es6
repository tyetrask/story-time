import React from 'react';
import ReactDOM from 'react-dom';

class TimingMyWork extends React.Component {

  render() {
    let stories = this.props.stories.map((story => {
      return (<TimingSharedStory
              key={story.id}
              story={story}
              selectedStory={this.props.selectedStory}
              setSelectedStory={this.props.setSelectedStory}
              areCompletedStoriesVisible={this.props.areCompletedStoriesVisible}
              />);
      }));
    return <div>
             {stories}
           </div>;
  }

}

window.TimingMyWork = TimingMyWork;
