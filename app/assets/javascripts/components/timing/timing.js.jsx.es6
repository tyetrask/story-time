class Timing extends React.Component {

  constructor() {
    super()
    this.state = {
      me: null,
      meExternal: {name: 'Developer'},
      projects: [],
      notifications: [],
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
      'setCompletedStoriesVisibility'
    ]
    methods.forEach((method) => { this[method] = this[method].bind(this); });
  }

  componentWillMount() {
    this.loadMe()
  }

  componentDidMount() {
    this.calculateScreenHeight();
    return this.attachControlPanelHandler();
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
        return this.pushNotification(`We're sorry. There was an error loading your external account. ${errorThrown}`);
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
        console.log(data)
        return this.setState({meExternal: data}, this.loadProjects);
      },
      error(jqXHR, textStatus, errorThrown) {
        return this.pushNotification(`We're sorry. There was an error loading your external account. ${errorThrown}`);
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
        return this.pushNotification(`We're sorry. There was an error loading projects. ${errorThrown}`);
      }
    });
  }

  calculateScreenHeight() {
    let window_height = $(window).height();
    let navigation_height = $('#navigation-container').height();
    this.setState({screenHeight: (window_height - navigation_height - 20)}); // 20 pixels height for div.spacer-sm
    $('#stories-container').css('height', this.state.screenHeight);
    return $('#clock-container').css('height', this.state.screenHeight);
  }

  attachControlPanelHandler() {
    // TODO: Probably reactify this a bit more at some point.
    return $('#control-panel-toggle a').click(function(e) {
      $('#control-panel-container').slideToggle();
      return $('#control-panel-toggle').toggleClass('active');
    });
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
        return this.pushNotification(`We're sorry. There was an error loading your work stories. ${errorThrown}`);
      }
    });
    return $.ajax({
      type: 'get',
      dataType: 'json',
      url: `/story_interface/${this.state.resourceInterface}/projects/${this.state.selectedProject.id}/iterations`,
      context: this,
      success(data) {
        let upcoming_stories = [];
        data.map(iteration =>
          iteration.stories.map(pivotal_story => upcoming_stories.push(pivotal_story))
        );
        return this.setState({upcoming: upcoming_stories}, this.buildEpicList);
      },
      error(jqXHR, textStatus, errorThrown) {
        return this.pushNotification(`We're sorry. There was an error loading upcoming stories. ${errorThrown}`);
      }
    });
  }

  buildEpicList() {
    let epicList = [];
    this.state.upcoming.map(story =>
      story.labels.map(label_object => epicList.push(label_object.name))
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
          return this.pushNotification(`We're sorry. More than one open working story was detected. ${errorThrown}`);
        } else if (data.length === 1) {
          let open_work_time_unit = data[0];
          if (open_work_time_unit.project_id === this.state.selectedProject.id) {
            let workingStory = _.find(_.union(this.state.myWork, this.state.upcoming), {id: data[0].story_id});
            return this.setWorkingStory(workingStory);
          } else {
            let open_project = _.find(this.state.projects, {id: open_work_time_unit.project_id});
            return this.pushNotification(`You are currently working on a story in another Project. (${open_project.name})`);
          }
        }
      },
      error(jqXHR, textStatus, errorThrown) {
        return this.pushNotification(`We're sorry. There was an error loading the open working story. ${errorThrown}`);
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

  updateStoryState(story, new_state) {
    // TODO: Add user to the list of owner_ids for the story, if going from unstarted -> started
    return false; // Remove when ready to implement.
    return $.ajax({
      type: 'patch',
      dataType: 'json',
      data: {new_story_params: {current_state: new_state}},
      url: `/story_interface/${this.state.resourceInterface}/projects/${story.project_id}/stories/${story.id}`,
      context: this,
      success(data) {
        let story_set;
        let modified_story = _.clone(story);
        modified_story.current_state = new_state;
        if (_.contains(this.state.myWork, story)) {
          story_set = _.clone(this.state.myWork);
          story_set[story_set.indexOf(story)] = modified_story;
          this.setState({myWork: story_set});
        }
        if (_.contains(this.state.upcoming, story)) {
          story_set = _.clone(this.upcoming.myWork);
          story_set[story_set.indexOf(story)] = modified_story;
          this.setState({upcoming: story_set});
        }
        if (story === this.state.selectedStory) {
          return this.setState({selectedStory: modified_story});
        }
      },
      error(jqXHR, textStatus, errorThrown) {
        return this.pushNotification(`We're sorry. There was an error updating the story state. ${errorThrown}`);
      }
    });
  }

  updateUserSettings(user_settings) {
    // TODO: Don't steamroll user settings whenever this is called. merge?
    return $.ajax({
      type: 'patch',
      dataType: 'json',
      data: {user: {settings: user_settings}},
      url: `/users/${this.state.me.id}`,
      context: this,
      success(data) {
        let user = _.clone(this.state.me);
        user.settings = user_settings;
        return this.setState({me: user});
      },
      error(jqXHR, textStatus, errorThrown) {
        return this.pushNotification(`We're sorry. There was an error updating your user settings. ${errorThrown}`);
      }
    });
  }

  setCompletedStoriesVisibility(areCompletedStoriesVisible) {
    return this.setState({areCompletedStoriesVisible: areCompletedStoriesVisible});
  }

  pushNotification(notification_text) {
    let notification_set = _.clone(this.state.notifications);
    notification_set.push(notification_text);
    return this.setState({notifications: notification_set});
  }

  dismissNotification() {
    let notification_set = _.clone(this.state.notifications);
    notification_set.shift();
    return this.setState({notifications: notification_set});
  }

  render() {
    return (<div>
            <TimingControlPanel
              selectedProject={this.state.selectedProject}
              setSelectedProject={this.setSelectedProject}
              projects={this.state.projects}
              areCompletedStoriesVisible={this.state.areCompletedStoriesVisible}
              setCompletedStoriesVisibility={this.setCompletedStoriesVisibility}
            />
            <div className='spacer-sm'></div>
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
            <Notifications
              notifications={this.state.notifications}
              dismissNotification={this.dismissNotification}
            />
           </div>);
  }
}

window.Timing = Timing;
