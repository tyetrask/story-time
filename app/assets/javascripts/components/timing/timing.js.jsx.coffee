###* @jsx React.DOM ###

window.Timing = React.createClass
  
  getDefaultProps: ->
    {
      resource_interface: 'pivotal_tracker',
      screen_height: 1000,
      me: {name: 'Developer'},
      projects: [],
      my_work: [],
      upcoming: []
    }
  
  getInitialState: ->
    {
      selected_project: null,
      selected_story: null
    }
  
  componentDidMount: ->
    @calculateScreenHeight()
    @junkToReactify()
    _this = @
    # Load 'me'
    $.ajax
      type: 'get'
      dataType: 'json'
      url: "/story_interface/#{_this.props.resource_interface}/me"
      success: (data) ->
        _this.setProps({me: data})
      error: (jqXHR, textStatus, errorThrown) ->
        console.log "ajax call error: #{errorThrown}"
    # Load 'projects'
    $.ajax
      type: 'get'
      dataType: 'json'
      url: "/story_interface/#{_this.props.resource_interface}/projects"
      success: (data) ->
        _this.setProps({projects: data})
        _this.setSelectedProject(_this.props.projects[1])
      error: (jqXHR, textStatus, errorThrown) ->
        console.log "ajax call error: #{errorThrown}"
  
  
  calculateScreenHeight: ->
    window_height = $(window).height()
    navigation_height = $('#navigation-container').height()
    @setState({screen_height: (window_height - navigation_height - 20)}) # 20 pixels padding-top on #timing-container
    $('#stories-container').css('height', @state.screen_height)
    $('#clock-container').css('height', @state.screen_height)
  
  
  junkToReactify: ->
    console.log 'Hey dummy. This stuff needs to be reactified at some point.'
    $('#control-panel-toggle a').click (e) ->
      $('#control-panel-container').slideToggle()
      if $('#control-panel-container').is(":visible")
        $('#control-panel-toggle').addClass('active')
      else
        $('#control-panel-toggle').removeClass('active')
    
    $('#control-panel-me').html("<strong>Me:</strong> #{@props.me.id}")
    
    $('#control-panel-project-name').html("a PROJECT NAME lol")
    @props.projects.map (project_object) ->
      $('#project-list').append("<li><a>#{project_object.name}</a></li>")
  
  
  setSelectedProject: (pivotal_project) ->
    @setState({selected_project: pivotal_project})
    @loadStories()
  
  
  setSelectedStory: (story) ->
    @setState({selected_story: story})
  
  
  loadStories: ->
    _this = @
    # Load 'my work'
    $.ajax
      type: 'get'
      dataType: 'json'
      url: "/story_interface/#{_this.props.resource_interface}/projects/#{_this.state.selected_project.id}/my_work"
      success: (data) ->
        _this.setProps({my_work: data})
      error: (jqXHR, textStatus, errorThrown) ->
        console.log "ajax call error: #{errorThrown}"
    # Load 'upcoming'
    $.ajax
      type: 'get'
      dataType: 'json'
      url: "/story_interface/#{_this.props.resource_interface}/projects/#{_this.state.selected_project.id}/iterations"
      success: (data) ->
        upcoming_stories = []
        data.map (iteration) ->
          iteration.stories.map (pivotal_story) ->
            upcoming_stories.push(pivotal_story)
        _this.setProps({upcoming: upcoming_stories})
      error: (jqXHR, textStatus, errorThrown) ->
        console.log "ajax call error: #{errorThrown}"

  
  render: ->
    `<div>
      <TimingStories my_work={this.props.my_work} upcoming={this.props.upcoming} selected_story={this.state.selected_story} setSelectedStory={this.setSelectedStory} />
      <TimingClock selected_story={this.state.selected_story} />
     </div>`
