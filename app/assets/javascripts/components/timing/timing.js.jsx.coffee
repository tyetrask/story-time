###* @jsx React.DOM ###

window.Timing = React.createClass
  
  getDefaultProps: ->
    {
      me: {name: 'Developer'},
      projects: []
    }
  
  getInitialState: ->
    {
      is_loading: true,
      resource_interface: 'pivotal_tracker',
      screen_height: 1000,
      completed_stories_visible: false,
      my_work: [],
      upcoming: [],
      selected_project: null,
      selected_story: null
    }
  
  componentWillMount: ->
    _this = @
    $.ajax
      type: 'get'
      dataType: 'json'
      url: "/story_interface/#{_this.state.resource_interface}/me"
      success: (data) ->
        _this.setProps({me: data})
      error: (jqXHR, textStatus, errorThrown) ->
        console.log "ajax call error: #{errorThrown}"
    $.ajax
      type: 'get'
      dataType: 'json'
      url: "/story_interface/#{_this.state.resource_interface}/projects"
      success: (data) ->
        _this.setProps({projects: data})
        _this.setSelectedProject(_this.props.projects[1])
      error: (jqXHR, textStatus, errorThrown) ->
        console.log "ajax call error: #{errorThrown}"
  
  
  componentDidMount: ->
    @calculateScreenHeight()
    @attachControlPanelHandler()
    $(document)
      .ajaxStop((->
        @setState { is_loading: false }
        ).bind(@))
      .ajaxStart((->
        @setState { is_loading: true }
        ).bind(@))
  
  
  calculateScreenHeight: ->
    window_height = $(window).height()
    navigation_height = $('#navigation-container').height()
    @setState({screen_height: (window_height - navigation_height - 20)}) # 20 pixels padding-top on #timing-container
    $('#stories-container').css('height', @state.screen_height)
    $('#clock-container').css('height', @state.screen_height)
  
  
  attachControlPanelHandler: ->
    # Probably reactify this a bit more at some point.
    $('#control-panel-toggle a').click (e) ->
      $('#control-panel-container').slideToggle()
      $('#control-panel-toggle').toggleClass('active')
  
  
  loadStories: ->
    _this = @
    @setState({my_work: [], upcoming: [], is_loading: true})
    $.ajax
      type: 'get'
      dataType: 'json'
      url: "/story_interface/#{_this.state.resource_interface}/projects/#{_this.state.selected_project.id}/my_work"
      success: (data) ->
        _this.setState({my_work: data})
      error: (jqXHR, textStatus, errorThrown) ->
        console.log "ajax call error: #{errorThrown}"
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
        console.log "ajax call error: #{errorThrown}"
  
  
  setSelectedProject: (project) ->
    @setState({selected_project: project, selected_story: null}, @loadStories)
  
  
  setSelectedStory: (story) ->
    @setState({selected_story: story})

  
  render: ->
    `<div>
      <TimingControlPanel selected_project={this.state.selected_project} setSelectedProject={this.setSelectedProject} projects={this.props.projects} completed_stories_visible={this.state.completed_stories_visible} />
      <div className='spacer-sm'></div>
      <TimingStories my_work={this.state.my_work} upcoming={this.state.upcoming} selected_story={this.state.selected_story} setSelectedStory={this.setSelectedStory} />
      <TimingClock selected_story={this.state.selected_story} />
      <TimingLoadingIndicator is_loading={this.state.is_loading} />
     </div>`
