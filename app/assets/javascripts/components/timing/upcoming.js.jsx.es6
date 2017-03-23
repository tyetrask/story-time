import React from 'react';
import ReactDOM from 'react-dom';

class TimingUpcoming extends React.Component {

  constructor() {
    super()
    this.state = {epicFilterValue: null};
  }

  handleEpicSelect(e) {
    return this.setState({epicFilterValue: $(e.target).attr('data-epic')});
  }

  handleClearEpicFilter() {
    return this.setState({epicFilterValue: null});
  }

  filterMenuDisplayText() {
    if (this.state.epicFilterValue) { return `Filter: ${this.state.epicFilterValue}`; } else { return 'Filter'; }
  }

  render() {
    let epicOptions = this.props.epicList.map((epicName => {
      let epicKey = `epic-${epicName}`;
      return <li key={epicKey}>
               <a onClick={this.handleEpicSelect.bind(this)} data-epic={epicName}>{epicName}</a>
             </li>;
      }));
    let stories = this.props.upcoming.map((story => {
      if ((this.state.epicFilterValue === null) || _.find(story.labels, {name: this.state.epicFilterValue})) {
        return <TimingSharedStory
                key={story.id}
                story={story}
                selectedStory={this.props.selectedStory}
                setSelectedStory={this.props.setSelectedStory}
                areCompletedStoriesVisible={this.props.areCompletedStoriesVisible}
               />;
        }
      }));
    return (<div>
             <div className="pt-callout">
               <h5>Upcoming</h5>
             </div>
             <br />
             <div id="upcoming-story-list">
               {stories}
             </div>
           </div>);
  }

}

window.TimingUpcoming = TimingUpcoming;
