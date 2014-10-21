###* @jsx React.DOM ###

window.Timing = React.createClass
  
  getDefaultProps: ->
    {
      resource_interface: 'pivotal_tracker',
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
  
  
  setSelectedProject: (pivotal_project) ->
    @setState({selected_project: pivotal_project})
    @loadStories()
  
  
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
        _this.setProps({upcoming: data})
      error: (jqXHR, textStatus, errorThrown) ->
        console.log "ajax call error: #{errorThrown}"

  
  render: ->
    `<div>
      <TimingStories my_work={this.props.my_work} />
      <TimingClock />
     </div>`
