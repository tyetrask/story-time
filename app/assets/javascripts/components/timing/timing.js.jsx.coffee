###* @jsx React.DOM ###

window.Timing = React.createClass
  
  getDefaultProps: ->
    {
      me: {name: 'Developer'}
      me_external: {name: 'Developer'},
      projects: []
    }
  
  getInitialState: ->
    {
      notifications: []
      resource_interface: 'pivotal_tracker',
      screen_height: 1000,
      completed_stories_visible: false,
      my_work: [],
      upcoming: [],
      selected_project: null,
      selected_story: null,
      working_story: null
    }
  
  componentWillMount: ->
    _this = @
    $.ajax
      type: 'get'
      dataType: 'json'
      url: "/users/me"
      success: (data) ->
        _this.setProps({me: data})
      error: (jqXHR, textStatus, errorThrown) ->
        _this.pushNotification("We're sorry. There was an error loading your account. #{errorThrown}")
    $.ajax
      type: 'get'
      dataType: 'json'
      url: "/story_interface/#{_this.state.resource_interface}/me"
      success: (data) ->
        _this.setProps({me_external: data})
      error: (jqXHR, textStatus, errorThrown) ->
        _this.pushNotification("We're sorry. There was an error loading your external account. #{errorThrown}")
    $.ajax
      type: 'get'
      dataType: 'json'
      url: "/story_interface/#{_this.state.resource_interface}/projects"
      success: (data) ->
        _this.setProps({projects: data})
        _this.setSelectedProject(_this.props.projects[1])
      error: (jqXHR, textStatus, errorThrown) ->
        _this.pushNotification("We're sorry. There was an error loading projects. #{errorThrown}")
  
  
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
    _this = @
    @setState({my_work: [], upcoming: []})
    $.ajax
      type: 'get'
      dataType: 'json'
      url: "/story_interface/#{_this.state.resource_interface}/projects/#{_this.state.selected_project.id}/my_work"
      success: (data) ->
        _this.setState({my_work: data})
        _this.loadOpenWorkTimeUnit()
      error: (jqXHR, textStatus, errorThrown) ->
        _this.pushNotification("We're sorry. There was an error loading your work stories. #{errorThrown}")
    $.ajax
      type: 'get'
      dataType: 'json'
      url: "/story_interface/#{_this.state.resource_interface}/projects/#{_this.state.selected_project.id}/iterations"
      success: (data) ->
        upcoming_stories = []
        data.map (iteration) ->
          iteration.stories.map (pivotal_story) ->
            upcoming_stories.push(pivotal_story)
        _this.setState({upcoming: upcoming_stories})
      error: (jqXHR, textStatus, errorThrown) ->
        _this.pushNotification("We're sorry. There was an error loading upcoming stories. #{errorThrown}")
  
  
  loadOpenWorkTimeUnit: ->
    _this = @
    $.ajax
      type: 'get'
      dataType: 'json'
      data: {open_work_time_units: true, work_time_unit: {user_id: _this.props.me_external.id} }
      url: "/work_time_units"
      success: (data) ->
        if data.length > 1
          console.log "more than one working story detected. danger!"
        else if data.length == 1
          open_work_time_unit = data[0]
          all_stories = _.union(_this.state.my_work, _this.state.upcoming)
          working_story = _.find(all_stories, {id: open_work_time_unit.story_id })
          if working_story
            _this.setState({working_story: working_story})
          else
            # TODO: Implement switching to another project's story
            _this.setState({working_story: {hey: 'the princess(working story) is in another castle(project)'}})
      error: (jqXHR, textStatus, errorThrown) ->
        _this.pushNotification("We're sorry. There was an error loading the open work time unit. #{errorThrown}")
  
  
  setSelectedProject: (project) ->
    @setState({selected_project: project, selected_story: null}, @loadStories)
  
  
  setSelectedStory: (story) ->
    @setState({selected_story: story})
  
  
  setWorkingStory: (story) ->
    @setState({working_story: story})
  
  
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
      <TimingControlPanel selected_project={this.state.selected_project} setSelectedProject={this.setSelectedProject} projects={this.props.projects} completed_stories_visible={this.state.completed_stories_visible} setCompletedStoriesVisibility={this.setCompletedStoriesVisibility} />
      <div className='spacer-sm'></div>
      <TimingStories my_work={this.state.my_work} upcoming={this.state.upcoming} selected_story={this.state.selected_story} setSelectedStory={this.setSelectedStory} completed_stories_visible={this.state.completed_stories_visible} />
      <TimingClock me={this.props.me} selected_story={this.state.selected_story} working_story={this.state.working_story} setWorkingStory={this.setWorkingStory} setSelectedStory={this.setSelectedStory} pushNotification={this.pushNotification} />
      <Notifications notifications={this.state.notifications} dismissNotification={this.dismissNotification} />
     </div>`
