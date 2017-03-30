import React from 'react';
import ReactDOM from 'react-dom';
import { ProgressBar, Toaster, Position, Intent } from '@blueprintjs/core';
var _ = require('lodash');

class Workspace extends React.Component {

  constructor() {
    super()
    this.state = {
      currentUser: null,
      currentUserExternal: null,
      projects: [],
      selectedIntegrationID: null,
      selectedProjectID: null,
      selectedStoryID: null,
      stories: [],
      workingStoryID: null
    };
    this.refHandlers = {
        notifier: (ref) => { this.notifier = ref },
    };
    let methodsToBind = [
      'setSelectedIntegrationID',
      'setSelectedProjectID',
      'setSelectedStoryID',
      'setWorkingStoryID',
      'pushNotification',
      'updateStoryState'
    ]
    methodsToBind.forEach((method) => { this[method] = this[method].bind(this); });
  }

  componentWillMount() {
    this.loadCurrentUser()
  }

  componentDidMount() {
    this.configureNotifier();
  }

  configureNotifier() {
    this.notifier = Toaster.create({
      position: Position.TOP_LEFT,
    }, document.body);
  }

  loadCurrentUser() {
    $.ajax({
      type: 'get',
      dataType: 'json',
      url: `/users/current__user`,
      context: this,
      success(data) {
        let selectedIntegrationID = null;
        let currentUser = data.user
        if (currentUser.integrations.length > 0) {
          // TODO Save "last" selected integration to database
          selectedIntegrationID = currentUser.integrations[0].id
        }
        this.setState({
          currentUser: currentUser,
          selectedIntegrationID: selectedIntegrationID
          }, this.loadCurrentUserExternal
        );
      },
      error(jqXHR, textStatus, errorThrown) {
        this.pushNotification({
          message: `We're sorry. There was an error loading your external account. ${errorThrown}`,
          intent: Intent.DANGER
        });
      }
    });
  }

  loadCurrentUserExternal() {
    if (this.state.selectedIntegrationID === null) {
      return;
    }
    $.ajax({
      type: 'get',
      dataType: 'json',
      url: `/integrations/${this.state.selectedIntegrationID}/external_resources/current__user`,
      context: this,
      success(data) {
        this.setState({currentUserExternal: data}, this.loadProjects);
      },
      error(jqXHR, textStatus, errorThrown) {
        this.pushNotification({
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
      url: `/integrations/${this.state.selectedIntegrationID}/external_resources/projects`,
      context: this,
      success(data) {
        this.setState({projects: data});
        if (this.state.currentUser.settings.last_viewed_project_id) {
          let lastViewedProject = _.find(this.state.projects, {id: parseInt(this.state.currentUser.settings.last_viewed_project_id)});
          this.setSelectedProjectID(lastViewedProject.id);
        } else {
          this.setSelectedProjectID(this.state.projects[0].id);
        }
      },
      error(jqXHR, textStatus, errorThrown) {
        this.pushNotification({
          message: `We're sorry. There was an error loading projects. ${errorThrown}`,
          intent: Intent.DANGER
        });
      }
    });
  }

  loadStories() {
    this.setState({stories: []});
    $.ajax({
      type: 'get',
      dataType: 'json',
      url: `/integrations/${this.state.selectedIntegrationID}/external_resources/projects/${this.state.selectedProjectID}/iterations`,
      context: this,
      success(data) {
        let stories = _.flatten(data.map(iteration =>
          iteration.stories.map(pivotal_story => pivotal_story)
        ));
        this.setState({stories: stories}, this.loadOpenWorkTimeUnit);
      },
      error(jqXHR, textStatus, errorThrown) {
        this.pushNotification({
          message: `We're sorry. There was an error loading upcoming stories. ${errorThrown}`,
          intent: Intent.DANGER
        });
      }
    });
  }

  loadOpenWorkTimeUnit() {
    $.ajax({
      type: 'get',
      dataType: 'json',
      data: {open_work_time_units: true, work_time_unit: {integration_user_id: this.state.currentUserExternal.id} },
      url: "/work_time_units",
      context: this,
      success(data) {
        if (data.length > 1) {
          this.pushNotification({
            message: `We're sorry. More than one open working story was detected.`,
            intent: Intent.DANGER
          });
        } else if (data.length === 1) {
          let workTimeUnit = data[0];
          if (workTimeUnit.project_id === this.state.selectedProjectID) {
            let workingStory = _.find(this.state.stories, {id: data[0].story_id});
            if (workingStory) {
              this.setWorkingStoryID(workingStory.id);
            }
          } else {
            let openProject = _.find(this.state.projects, {id: workTimeUnit.project_id});
            this.pushNotification({
              message: `You are currently working on a story in another Project. (${openProject.name})`,
              intent: Intent.WARNING
            });
          }
        }
      },
      error(jqXHR, textStatus, errorThrown) {
        this.pushNotification({
          message: `We're sorry. There was an error loading the open working story. ${errorThrown}`,
          intent: Intent.DANGER
        });
      }
    });
  }

  setSelectedIntegrationID(integrationID) {
    this.setState({setSelectedIntegrationID: integrationID, selectedProjectID: null, selectedStoryID: null}, this.loadCurrentUserExternal)
  }

  setSelectedProjectID(projectID) {
    this.setState({selectedProjectID: projectID, selectedStoryID: null}, this.loadStories);
    this.updateUserSettings({last_viewed_project_id: projectID});
  }

  setSelectedStoryID(storyID) {
    this.setState({selectedStoryID: storyID});
  }

  setWorkingStoryID(storyID) {
    this.setState({workingStoryID: storyID});
  }

  updateStoryState(storyID, newState) {
    let story = _.find(this.state.stories, {id: storyID})
    $.ajax({
      type: 'patch',
      dataType: 'json',
      data: {
        story: {
          current_state: newState,
          owner_ids: [this.state.currentUserExternal.id]
        }
      },
      url: `/integrations/${this.state.selectedIntegrationID}/external_resources/projects/${story.project_id}/stories/${story.id}`,
      context: this,
      success(data) {
        let stories = _.cloneDeep(this.state.stories)
        story = _.find(stories, {id: storyID})
        stories[stories.indexOf(story)] = data
        this.setState({stories: stories})
      },
      error(jqXHR, textStatus, errorThrown) {
        this.pushNotification({
          message: `We're sorry. There was an error updating the story state. ${errorThrown}`,
          intent: Intent.DANGER
        });
      }
    });
  }

  updateUserSettings(userSettings) {
    // TODO: Don't steamroll user settings whenever this is called. merge?
    $.ajax({
      type: 'patch',
      dataType: 'json',
      data: {user: {settings: userSettings}},
      url: `/users/${this.state.currentUser.id}`,
      context: this,
      success(data) {
        let currentUser = _.clone(this.state.currentUser);
        currentUser.settings = userSettings;
        this.setState({currentUser: currentUser});
      },
      error(jqXHR, textStatus, errorThrown) {
        this.pushNotification({
          message: `We're sorry. There was an error updating your user settings. ${errorThrown}`,
          intent: Intent.DANGER
        });
      }
    });
  }

  pushNotification(notification) {
    this.notifier.show(notification)
  }

  render() {
    return (<div>
            <NavigationHeader
              currentUser={this.state.currentUser}
              projects={this.state.projects}
              setSelectedIntegrationID={this.setSelectedIntegrationID}
              setSelectedProjectID={this.setSelectedProjectID}
              toggleTheme={this.props.toggleTheme}
            />
            <div className="spacer-sm"></div>
            <div id="timing-container">
              <StoryList
                currentUserExternal={this.state.currentUserExternal}
                stories={this.state.stories}
                selectedStoryID={this.state.selectedStoryID}
                setSelectedStoryID={this.setSelectedStoryID}
              />
              <WorkingStory
                currentUserExternal={this.state.currentUserExternal}
                selectedIntegrationID={this.state.selectedIntegrationID}
                selectedStoryID={this.state.selectedStoryID}
                selectedProjectID={this.state.selectedProjectID}
                stories={this.state.stories}
                workingStoryID={this.state.workingStoryID}
                setWorkingStoryID={this.setWorkingStoryID}
                setSelectedStoryID={this.setSelectedStoryID}
                updateStoryState={this.updateStoryState}
                pushNotification={this.pushNotification}
              />
            </div>
            <Toaster ref={this.refHandlers.notifier} />
           </div>);
  }
}

window.Workspace = Workspace;
