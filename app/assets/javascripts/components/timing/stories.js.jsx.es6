import React from 'react';
import ReactDOM from 'react-dom';
import { Button } from '@blueprintjs/core'
var _ = require('lodash');

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
              <div className="pt-button-group">
                <Button text="My Work" active={true} onClick={this.toggleViewing.bind(this)} />
                <Button text="Upcoming" active={false} onClick={this.toggleViewing.bind(this)} />
              </div>
             </div>
    } else {
      return <div className="pt-callout">
              <div className="pt-button-group">
                <Button text="My Work" active={false} onClick={this.toggleViewing.bind(this)} />
                <Button text="Upcoming" active={true} onClick={this.toggleViewing.bind(this)} />
              </div>
             </div>
    }
  }

  filteredStories() {
    if (this.state.viewing === 'my work') {
      return _.filter(this.props.stories, (story) => { return story.owner_ids.includes(this.props.meExternal.id) })
    }
    return this.props.stories
  }

  render() {
    let stories = this.filteredStories().map((story => {
      return (<TimingSharedStory
              key={story.id}
              story={story}
              selectedStory={this.props.selectedStory}
              setSelectedStory={this.props.setSelectedStory}
              areCompletedStoriesVisible={this.props.areCompletedStoriesVisible}
              />);
      }));
    return (<div id="stories-container">
             {this.storiesHeader()}
             <br />
             <div>
              {stories}
             </div>
           </div>);
  }

}

window.TimingStories = TimingStories;
