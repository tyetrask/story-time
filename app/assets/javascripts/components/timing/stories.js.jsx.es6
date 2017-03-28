import React from 'react';
import ReactDOM from 'react-dom';
import { Button } from '@blueprintjs/core'

class TimingStories extends React.Component {

  constructor() {
    super()
    this.state = {
      viewing: 'my work'
    }
  }

  toggleViewing() {
    if (this.state.viewing === 'my work') {
      this.setState({viewing: 'upcoming'})
    } else {
      this.setState({viewing: 'my work'})
    }
  }

  storiesHeader() {
    if (this.state.viewing === 'my work') {
      return <div className="pt-callout">
              <Button text="My Work" active={true} onClick={this.toggleViewing.bind(this)} />
              <Button text="Upcoming" active={false} onClick={this.toggleViewing.bind(this)} />
             </div>
    } else {
      return <div className="pt-callout">
              <Button text="My Work" active={false} onClick={this.toggleViewing.bind(this)} />
              <Button text="Upcoming" active={true} onClick={this.toggleViewing.bind(this)} />
             </div>
    }
  }

  render() {
    if (this.state.viewing === 'my work') {
      return (<div id="stories-container">
               {this.storiesHeader()}
               <br />
               <TimingMyWork
                 stories={this.props.myWork}
                 selectedStory={this.props.selectedStory}
                 setSelectedStory={this.props.setSelectedStory}
                 areCompletedStoriesVisible={this.props.areCompletedStoriesVisible}
               />
             </div>);
    }
    return (<div id="stories-container">
             {this.storiesHeader()}
             <br />
             <TimingMyWork
              stories={this.props.upcoming}
              selectedStory={this.props.selectedStory}
              setSelectedStory={this.props.setSelectedStory}
              areCompletedStoriesVisible={this.props.areCompletedStoriesVisible}
             />
           </div>);
  }

}

window.TimingStories = TimingStories;
