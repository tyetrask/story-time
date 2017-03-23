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
    return (<div className="panel panel-default">
             <div className="panel-heading text-center">
               <strong>Upcoming</strong>
               <div className="dropdown pull-right">
                 <a className="dropdown-toggle" data-toggle="dropdown">{this.filterMenuDisplayText()} <b className="caret"></b></a>
                 <ul className="dropdown-menu" role="menu">
                   <li><a onClick={this.handleClearEpicFilter.bind(this)}>(Clear Filter)</a></li>
                   {epicOptions}
                 </ul>
               </div>
             </div>
             <div id="upcoming-story-list" className="list-group">
               {stories}
             </div>
           </div>);
  }
}

window.TimingUpcoming = TimingUpcoming;
