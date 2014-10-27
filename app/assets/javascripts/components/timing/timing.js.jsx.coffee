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
      epic_list: [],
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
        _this.setState({upcoming: upcoming_stories}, _this.buildEpicList)
      error: (jqXHR, textStatus, errorThrown) ->
        _this.pushNotification("We're sorry. There was an error loading upcoming stories. #{errorThrown}")
  
  
  buildEpicList: ->
    epic_list = []
    @state.upcoming.map (story) ->
      story.labels.map (label_object) ->
        epic_list.push label_object.name
    epic_list = _.uniq(epic_list)
    @setState({epic_list: epic_list})
  
  
  loadOpenWorkTimeUnit: ->
    _this = @
    $.ajax
      type: 'get'
      dataType: 'json'
      data: {open_work_time_units: true, work_time_unit: {user_id: _this.props.me_external.id} }
      url: "/work_time_units"
      success: (data) ->
        if data.length > 1
          _this.pushNotification("We're sorry. More than one open working story was detected. #{errorThrown}")
        else if data.length == 1
          open_work_time_unit = data[0]
          if open_work_time_unit.project_id is _this.state.selected_project.id
            working_story = _.find(_.union(_this.state.my_work, _this.state.upcoming), {id: data[0].story_id})
            _this.setWorkingStory(working_story)
          else
            open_project = _.find(_this.props.projects, {id: open_work_time_unit.project_id})
            _this.pushNotification("You are currently working on a story in another Project. (#{open_project.name})")          
      error: (jqXHR, textStatus, errorThrown) ->
        _this.pushNotification("We're sorry. There was an error loading the open working story. #{errorThrown}")
  
  
  setSelectedProject: (project) ->
    @setState({selected_project: project, selected_story: null}, @loadStories)
  
  
  setSelectedStory: (story) ->
    @setState({selected_story: story})
  
  
  setWorkingStory: (story) ->
    @setState({working_story: story})
    if story then $('i.fa-fire').addClass('burning-animation') else $('i.fa-fire').removeClass('burning-animation')
  
  
  updateStoryState: (story, new_state) ->
    $.ajax
      type: 'patch'
      dataType: 'json'
      data: {new_story_params: {current_state: new_state}}
      url: "/story_interface/#{_this.state.resource_interface}/projects/#{story.project_id}/stories/#{story.id}"
      success: (data) ->
        _this.setState({upcoming: upcoming_stories}, _this.buildEpicList)
      error: (jqXHR, textStatus, errorThrown) ->
        _this.pushNotification("We're sorry. There was an error updating the story state. #{errorThrown}")
  
  
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
      <TimingStories my_work={this.state.my_work} upcoming={this.state.upcoming} epic_list={this.state.epic_list} selected_story={this.state.selected_story} setSelectedStory={this.setSelectedStory} completed_stories_visible={this.state.completed_stories_visible} />
      <TimingClock me_external={this.props.me_external} selected_story={this.state.selected_story} selected_project={this.state.selected_project} working_story={this.state.working_story} setWorkingStory={this.setWorkingStory} setSelectedStory={this.setSelectedStory} pushNotification={this.pushNotification} />
      <Notifications notifications={this.state.notifications} dismissNotification={this.dismissNotification} />
     </div>`
