window.Timing = React.createClass

  getInitialState: ->
    {
      me: @props.me
      me_external: {name: 'Developer'}
      projects: []
      notifications: []
      resource_interface: 'pivotal_tracker'
      screen_height: 1000
      completed_stories_visible: false
      my_work: []
      upcoming: []
      epic_list: []
      selected_project: null
      selected_story: null
      working_story: null
    }

  componentWillMount: ->
    $.ajax
      type: 'get'
      dataType: 'json'
      url: "/story_interface/#{@state.resource_interface}/me"
      context: @
      success: (data) ->
        @setState({me_external: data})
      error: (jqXHR, textStatus, errorThrown) ->
        @pushNotification("We're sorry. There was an error loading your external account. #{errorThrown}")
    $.ajax
      type: 'get'
      dataType: 'json'
      url: "/story_interface/#{@state.resource_interface}/projects"
      context: @
      success: (data) ->
        @setState({projects: data})
        if @state.me.settings.last_viewed_project_id
          last_viewed_project = _.find(@state.projects, {id: parseInt(@state.me.settings.last_viewed_project_id)})
          @setSelectedProject(last_viewed_project)
        else
          @setSelectedProject(@state.projects[0])
      error: (jqXHR, textStatus, errorThrown) ->
        @pushNotification("We're sorry. There was an error loading projects. #{errorThrown}")


  componentDidMount: ->
    @calculateScreenHeight()
    @attachControlPanelHandler()


  calculateScreenHeight: ->
    window_height = $(window).height()
    navigation_height = $('#navigation-container').height()
    @setState({screen_height: (window_height - navigation_height - 20)}) # 20 pixels height for div.spacer-sm
    $('#stories-container').css('height', @state.screen_height)
    $('#clock-container').css('height', @state.screen_height)


  attachControlPanelHandler: ->
    # TODO: Probably reactify this a bit more at some point.
    $('#control-panel-toggle a').click (e) ->
      $('#control-panel-container').slideToggle()
      $('#control-panel-toggle').toggleClass('active')


  loadStories: ->
    @setState({my_work: [], upcoming: []})
    $.ajax
      type: 'get'
      dataType: 'json'
      url: "/story_interface/#{@state.resource_interface}/projects/#{@state.selected_project.id}/my_work"
      context: @
      success: (data) ->
        @setState({my_work: data})
        @loadOpenWorkTimeUnit()
      error: (jqXHR, textStatus, errorThrown) ->
        @pushNotification("We're sorry. There was an error loading your work stories. #{errorThrown}")
    $.ajax
      type: 'get'
      dataType: 'json'
      url: "/story_interface/#{@state.resource_interface}/projects/#{@state.selected_project.id}/iterations"
      context: @
      success: (data) ->
        upcoming_stories = []
        data.map (iteration) ->
          iteration.stories.map (pivotal_story) ->
            upcoming_stories.push(pivotal_story)
        @setState({upcoming: upcoming_stories}, @buildEpicList)
      error: (jqXHR, textStatus, errorThrown) ->
        @pushNotification("We're sorry. There was an error loading upcoming stories. #{errorThrown}")


  buildEpicList: ->
    epic_list = []
    @state.upcoming.map (story) ->
      story.labels.map (label_object) ->
        epic_list.push label_object.name
    epic_list = _.uniq(epic_list)
    @setState({epic_list: epic_list})


  loadOpenWorkTimeUnit: ->
    $.ajax
      type: 'get'
      dataType: 'json'
      data: {open_work_time_units: true, work_time_unit: {user_id: @state.me_external.id} }
      url: "/work_time_units"
      context: @
      success: (data) ->
        if data.length > 1
          @pushNotification("We're sorry. More than one open working story was detected. #{errorThrown}")
        else if data.length == 1
          open_work_time_unit = data[0]
          if open_work_time_unit.project_id is @state.selected_project.id
            working_story = _.find(_.union(@state.my_work, @state.upcoming), {id: data[0].story_id})
            @setWorkingStory(working_story)
          else
            open_project = _.find(@state.projects, {id: open_work_time_unit.project_id})
            @pushNotification("You are currently working on a story in another Project. (#{open_project.name})")
      error: (jqXHR, textStatus, errorThrown) ->
        @pushNotification("We're sorry. There was an error loading the open working story. #{errorThrown}")


  setSelectedProject: (project) ->
    @setState({selected_project: project, selected_story: null}, @loadStories)
    @updateUserSettings({last_viewed_project_id: project.id})


  setSelectedStory: (story) ->
    @setState({selected_story: story})


  setWorkingStory: (story) ->
    @setState({working_story: story})
    if story then $('i.fa-fire').addClass('burning-animation') else $('i.fa-fire').removeClass('burning-animation')


  updateStoryState: (story, new_state) ->
    # TODO: Add user to the list of owner_ids for the story, if going from unstarted -> started
    return false # Remove when ready to implement.
    $.ajax
      type: 'patch'
      dataType: 'json'
      data: {new_story_params: {current_state: new_state}}
      url: "/story_interface/#{@state.resource_interface}/projects/#{story.project_id}/stories/#{story.id}"
      context: @
      success: (data) ->
        modified_story = _.clone(story)
        modified_story.current_state = new_state
        if _.contains(@state.my_work, story)
          story_set = _.clone(@state.my_work)
          story_set[story_set.indexOf(story)] = modified_story
          @setState({my_work: story_set})
        if _.contains(@state.upcoming, story)
          story_set = _.clone(@upcoming.my_work)
          story_set[story_set.indexOf(story)] = modified_story
          @setState({upcoming: story_set})
        if story is @state.selected_story
          @setState({selected_story: modified_story})
      error: (jqXHR, textStatus, errorThrown) ->
        @pushNotification("We're sorry. There was an error updating the story state. #{errorThrown}")


  updateUserSettings: (user_settings) ->
    # TODO: Don't steamroll user settings whenever this is called. merge?
    $.ajax
      type: 'patch'
      dataType: 'json'
      data: {user: {settings: user_settings}}
      url: "/users/#{@state.me.id}"
      context: @
      success: (data) ->
        user = _.clone(@state.me)
        user.settings = user_settings
        @setState({me: user})
      error: (jqXHR, textStatus, errorThrown) ->
        @pushNotification("We're sorry. There was an error updating your user settings. #{errorThrown}")


  setCompletedStoriesVisibility: (are_completed_stories_visible) ->
    @setState({completed_stories_visible: are_completed_stories_visible})


  pushNotification: (notification_text) ->
    notification_set = _.clone(@state.notifications)
    notification_set.push(notification_text)
    @setState({notifications: notification_set})


  dismissNotification: ->
    notification_set = _.clone(@state.notifications)
    notification_set.shift()
    @setState({notifications: notification_set})


  render: ->
    `<div>
      <TimingControlPanel
        selected_project={this.state.selected_project}
        setSelectedProject={this.setSelectedProject}
        projects={this.state.projects}
        completed_stories_visible={this.state.completed_stories_visible}
        setCompletedStoriesVisibility={this.setCompletedStoriesVisibility}
      />
      <div className='spacer-sm'></div>
      <TimingStories
        my_work={this.state.my_work}
        upcoming={this.state.upcoming}
        epic_list={this.state.epic_list}
        selected_story={this.state.selected_story}
        setSelectedStory={this.setSelectedStory}
        completed_stories_visible={this.state.completed_stories_visible}
      />
      <TimingClock
        me_external={this.state.me_external}
        selected_story={this.state.selected_story}
        selected_project={this.state.selected_project}
        working_story={this.state.working_story}
        setWorkingStory={this.setWorkingStory}
        setSelectedStory={this.setSelectedStory}
        updateStoryState={this.updateStoryState}
        pushNotification={this.pushNotification}
      />
      <Notifications
        notifications={this.state.notifications}
        dismissNotification={this.dismissNotification}
      />
     </div>`
