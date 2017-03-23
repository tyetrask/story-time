import React from 'react';
import ReactDOM from 'react-dom';
import { ProgressBar, Toaster, Position, Intent } from '@blueprintjs/core';
var _ = require('lodash');

class Timing extends React.Component {

  constructor() {
    super()
    this.state = {
      isLoading: false,
      me: null,
      meExternal: {name: 'Developer'},
      projects: [],
      resourceInterface: 'pivotal_tracker',
      screenHeight: 1000,
      areCompletedStoriesVisible: false,
      myWork: [],
      upcoming: [],
      epicList: [],
      selectedProject: null,
      selectedStory: null,
      workingStory: null
    };
    let methods = [
      'setSelectedProject',
      'setSelectedStory',
      'setWorkingStory',
      'setCompletedStoriesVisibility',
      'pushNotification'
    ]
    methods.forEach((method) => { this[method] = this[method].bind(this); });
    this.refHandlers = {
        notifier: (ref) => { this.notifier = ref },
    };
  }

  componentWillMount() {
    this.loadMe()
  }

  componentDidMount() {
    this.calculateScreenHeight();
    this.bindLoadingEvents();
    this.configureNotifier();
  }

  bindLoadingEvents() {
    $(document).ajaxStop((() => { this.setState({isLoading: false}); }))
    $(document).ajaxStart((() => { this.setState({isLoading: true}); }));
  }

  configureNotifier() {
    this.notifier = Toaster.create({
        position: Position.TOP_LEFT,
    }, document.body);
  }

  loadMe() {
    $.ajax({
      type: 'get',
      dataType: 'json',
      url: `/users/me`,
      context: this,
      success(data) {
        return this.setState({me: data}, this.loadExternalMe);
      },
      error(jqXHR, textStatus, errorThrown) {
        return this.pushNotification({
          message: `We're sorry. There was an error loading your external account. ${errorThrown}`,
          intent: Intent.DANGER
        });
      }
    });
  }

  loadExternalMe() {
    $.ajax({
      type: 'get',
      dataType: 'json',
      url: `/story_interface/${this.state.resourceInterface}/me`,
      context: this,
      success(data) {
        return this.setState({meExternal: data}, this.loadProjects);
      },
      error(jqXHR, textStatus, errorThrown) {
        return this.pushNotification({
          message: `We're sorry. There was an error loading your external account. ${errorThrown}`,
          intent: Intent.DANGER
        });
      }
    });
  }

  loadProjects() {
    $.ajax({
      type: 'get',
      dataType: 'json',
      url: `/story_interface/${this.state.resourceInterface}/projects`,
      context: this,
      success(data) {
        this.setState({projects: data});
        if (this.state.me.settings.last_viewed_project_id) {
          let last_viewed_project = _.find(this.state.projects, {id: parseInt(this.state.me.settings.last_viewed_project_id)});
          return this.setSelectedProject(last_viewed_project);
        } else {
          return this.setSelectedProject(this.state.projects[0]);
        }
      },
      error(jqXHR, textStatus, errorThrown) {
        return this.pushNotification({
          message: `We're sorry. There was an error loading projects. ${errorThrown}`,
          intent: Intent.DANGER
        });
      }
    });
  }

  calculateScreenHeight() {
    let windowHeight = $(window).height();
    this.setState({screenHeight: (windowHeight - 20)}); // 20 pixels height for div.spacer-sm
    $('#stories-container').css('height', this.state.screenHeight);
    return $('#clock-container').css('height', this.state.screenHeight);
  }

  loadStories() {
    this.setState({myWork: [], upcoming: []});
    $.ajax({
      type: 'get',
      dataType: 'json',
      url: `/story_interface/${this.state.resourceInterface}/projects/${this.state.selectedProject.id}/my_work`,
      context: this,
      success(data) {
        this.setState({myWork: data});
        return this.loadOpenWorkTimeUnit();
      },
      error(jqXHR, textStatus, errorThrown) {
        return this.pushNotification({
          message: `We're sorry. There was an error loading your work stories. ${errorThrown}`,
          intent: Intent.DANGER
        });
      }
    });
    return $.ajax({
      type: 'get',
      dataType: 'json',
      url: `/story_interface/${this.state.resourceInterface}/projects/${this.state.selectedProject.id}/iterations`,
      context: this,
      success(data) {
        let upcomingStories = [];
        data.map(iteration =>
          iteration.stories.map(pivotal_story => upcomingStories.push(pivotal_story))
        );
        return this.setState({upcoming: upcomingStories}, this.buildEpicList);
      },
      error(jqXHR, textStatus, errorThrown) {
        return this.pushNotification({
          message: `We're sorry. There was an error loading upcoming stories. ${errorThrown}`,
          intent: Intent.DANGER
        });
      }
    });
  }

  buildEpicList() {
    let epicList = [];
    this.state.upcoming.map(story =>
      story.labels.map(label => epicList.push(label.name))
    );
    epicList = _.uniq(epicList);
    return this.setState({epicList});
  }

  loadOpenWorkTimeUnit() {
    return $.ajax({
      type: 'get',
      dataType: 'json',
      data: {open_work_time_units: true, work_time_unit: {user_id: this.state.meExternal.id} },
      url: "/work_time_units",
      context: this,
      success(data) {
        if (data.length > 1) {
          return this.pushNotification({
            message: `We're sorry. More than one open working story was detected.`,
            intent: Intent.DANGER
          });
        } else if (data.length === 1) {
          let openWorkTimeUnit = data[0];
          if (openWorkTimeUnit.project_id === this.state.selectedProject.id) {
            let workingStory = _.find(_.union(this.state.myWork, this.state.upcoming), {id: data[0].story_id});
            return this.setWorkingStory(workingStory);
          } else {
            let openProject = _.find(this.state.projects, {id: openWorkTimeUnit.project_id});
            return this.pushNotification({
              message: `You are currently working on a story in another Project. (${openProject.name})`,
              intent: Intent.WARNING
            });
          }
        }
      },
      error(jqXHR, textStatus, errorThrown) {
        return this.pushNotification({
          message: `We're sorry. There was an error loading the open working story. ${errorThrown}`,
          intent: Intent.DANGER
        });
      }
    });
  }

  setSelectedProject(project) {
    this.setState({selectedProject: project, selectedStory: null}, this.loadStories);
    return this.updateUserSettings({last_viewed_project_id: project.id});
  }

  setSelectedStory(story) {
    return this.setState({selectedStory: story});
  }

  setWorkingStory(story) {
    this.setState({workingStory: story});
    if (story) { return $('i.fa-fire').addClass('burning-animation'); } else { return $('i.fa-fire').removeClass('burning-animation'); }
  }

  updateStoryState(story, newState) {
    // TODO: Add user to the list of owner_ids for the story, if going from unstarted -> started
    return false; // Remove when ready to implement.
    return $.ajax({
      type: 'patch',
      dataType: 'json',
      data: {new_story_params: {current_state: newState}},
      url: `/story_interface/${this.state.resourceInterface}/projects/${story.project_id}/stories/${story.id}`,
      context: this,
      success(data) {
        let storySet;
        let modifiedStory = _.clone(story);
        modifiedStory.current_state = newState;
        if (_.contains(this.state.myWork, story)) {
          storySet = _.clone(this.state.myWork);
          storySet[storySet.indexOf(story)] = modifiedStory;
          this.setState({myWork: storySet});
        }
        if (_.contains(this.state.upcoming, story)) {
          storySet = _.clone(this.upcoming.myWork);
          storySet[storySet.indexOf(story)] = modifiedStory;
          this.setState({upcoming: storySet});
        }
        if (story === this.state.selectedStory) {
          return this.setState({selectedStory: modifiedStory});
        }
      },
      error(jqXHR, textStatus, errorThrown) {
        return this.pushNotification({
          message: `We're sorry. There was an error updating the story state. ${errorThrown}`,
          intent: Intent.DANGER
        });
      }
    });
  }

  updateUserSettings(userSettings) {
    // TODO: Don't steamroll user settings whenever this is called. merge?
    return $.ajax({
      type: 'patch',
      dataType: 'json',
      data: {user: {settings: userSettings}},
      url: `/users/${this.state.me.id}`,
      context: this,
      success(data) {
        let user = _.clone(this.state.me);
        user.settings = userSettings;
        return this.setState({me: user});
      },
      error(jqXHR, textStatus, errorThrown) {
        return this.pushNotification({
          message: `We're sorry. There was an error updating your user settings. ${errorThrown}`,
          intent: Intent.DANGER
        });
      }
    });
  }

  setCompletedStoriesVisibility(areCompletedStoriesVisible) {
    return this.setState({areCompletedStoriesVisible: areCompletedStoriesVisible});
  }

  pushNotification(notification) {
    this.notifier.show(notification)
  }

  loadingIndicator() {
    let spacerClass = 'spacer-sm'
    let progressBar = null;
    if (this.state.isLoading) {
      spacerClass = 'spacer-sm loading-indicator'
      progressBar = <ProgressBar />
    }
    return <div>
            {progressBar}
            <div className={spacerClass}></div>
          </div>
  }

  render() {
    return (<div>
            <NavigationHeader />
            {this.loadingIndicator()}
            <div id="timing-container">
              <TimingStories
                myWork={this.state.myWork}
                upcoming={this.state.upcoming}
                epicList={this.state.epicList}
                selectedStory={this.state.selectedStory}
                setSelectedStory={this.setSelectedStory}
                areCompletedStoriesVisible={this.state.areCompletedStoriesVisible}
              />
              <TimingClock
                meExternal={this.state.meExternal}
                selectedStory={this.state.selectedStory}
                selectedProject={this.state.selectedProject}
                workingStory={this.state.workingStory}
                setWorkingStory={this.setWorkingStory}
                setSelectedStory={this.setSelectedStory}
                updateStoryState={this.updateStoryState}
                pushNotification={this.pushNotification}
              />
            </div>
            <Toaster ref={this.refHandlers.notifier} />
           </div>);
  }
}

window.Timing = Timing;
