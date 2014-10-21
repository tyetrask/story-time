class Timing
  
  screen_height: 0
  
  resource_interface: null
  
  me: null
  current_project: null
  all_pivotal_projects: []
  
  my_work_stories: []
  upcoming_stories: []
  
  focus_pivotal_story: null
  focus_work_time_units: []
  
  pivotal_story_template = _.template("<a data-pivotal-story-id='<%= pivotal_story.id %>' class='list-group-item pivotal-story <%= pivotal_story_state_class %>'><span class='pull-right'><i class='fa fa-clock-o'></i> <%= pivotal_story.estimate %></span><p><%= pivotal_story.name %></p></a>")
  clock_story_template = _.template("<a class='list-group-item'><p><%= pivotal_story.name %></p><p><%= pivotal_story.description %></p><p>Estimation: <%= pivotal_story.estimate %></p></a><a class='list-group-item no-padding'><input class='simple' placeholder='comment'/></a><a id='work-time-unit-loading-placeholder' class='list-group-item'><p>loading work records <i class='fa fa-refresh fa-spin'></i></p></a><a class='list-group-item no-padding'><input id='start-work-button' type='submit' class='simple' value='Start Work'/></a>")
  stop_work_button_template = _.template("<a class='list-group-item no-padding'><input id='stop-work-button' type='submit' class='simple' value='Stop Work'/></a>")
  work_time_unit_template = _.template("<a data-work-time-unit-id='<%= work_time_unit.id %>' class='list-group-item work-time-unit'><p><i class='fa fa-pencil'></i> <i class='fa fa-trash'></i> Developer: <%= work_time_unit.user_id %><span class='pull-right'><span class='time-range'><%= started_at_formatted %> - <%= finished_at_formatted %></span> <small><%= total_time_in_seconds_formatted %></small></span></p></a>")
  
  
  
  constructor: ->
    _this = @
    
    # TODO: Later, we'll set this in the user record, I think.
    @resource_interface = 'pivotal_tracker'
    
    @me = null
    @current_project = null
    @all_pivotal_projects = []
    @my_work_stories = []
    @upcoming_stories = []
    @focus_pivotal_story = null
    @focus_work_time_units = []
    
    @setSizeOfStoryContainer()
    
    @loadMe()
    @loadProjects()
    $('#control-panel-toggle a').click (e) ->
      _this.toggleControlPanelVisibility()
  
  
  # Setup Functions
  
  setSizeOfStoryContainer: ->
    window_height = $(window).height()
    navigation_height = $('#navigation-container').height()
    @screen_height = (window_height - navigation_height - 20) # 20 pixels padding-top on #timing-container
    $('#stories-container').css('height', @screen_height)
  
  
  # Load Functions
  
  loadMe: ->
    _this = @
    $.ajax
      type: 'get'
      dataType: 'json'
      url: "/story_interface/#{_this.resource_interface}/me"
      success: (data) ->
        _this.me = data
        _this.populateMe()
      error: (jqXHR, textStatus, errorThrown) ->
        console.log "ajax call error: #{errorThrown}"
  
  
  loadProjects: ->
    _this = @
    $.ajax
      type: 'get'
      dataType: 'json'
      url: "/story_interface/#{_this.resource_interface}/projects"
      success: (data) ->
        data.map (pivotal_project) ->
          _this.all_pivotal_projects.push(pivotal_project)
        _this.current_project = _this.all_pivotal_projects[1]
        _this.populateProjectsList()
        _this.loadMyWork()
        _this.loadUpcoming()
      error: (jqXHR, textStatus, errorThrown) ->
        console.log "ajax call error: #{errorThrown}"
  
  
  loadMyWork: ->
    _this = @
    $.ajax
      type: 'get'
      dataType: 'json'
      url: "/story_interface/#{_this.resource_interface}/projects/#{_this.current_project.id}/my_work"
      success: (data) ->
        data.map (pivotal_story) ->
          _this.my_work_stories.push(pivotal_story)
        _this.populateMyWork()
      error: (jqXHR, textStatus, errorThrown) ->
        console.log "ajax call error: #{errorThrown}"
  
  
  loadUpcoming: ->
    _this = @
    $.ajax
      type: 'get'
      dataType: 'json'
      url: "/story_interface/#{_this.resource_interface}/projects/#{_this.current_project.id}/iterations"
      success: (data) ->
        data.map (iteration) ->
          iteration.stories.map (pivotal_story) ->
            _this.upcoming_stories.push(pivotal_story)
        _this.populateUpcoming()
        _this.attachStoryClickHandlers()
      error: (jqXHR, textStatus, errorThrown) ->
        console.log "ajax call error: #{errorThrown}"
  
  
  # Initial Display Functions
  
  populateMe: ->
    $('#control-panel-me').html("<strong>Me:</strong> #{@me.id}")
  
  populateProjectsList: ->
    _this = @
    $('#control-panel-project-name').html("#{@current_project.name}")
    @all_pivotal_projects.map (project_object) ->
      $('#project-list').append("<li><a>#{project_object.name}</a></li>")
  
  
  populateMyWork: ->
    _this = @
    @my_work_stories.map (pivotal_story) ->
      pivotal_story_html = pivotal_story_template
        pivotal_story: pivotal_story
        pivotal_story_state_class: if pivotal_story.current_state is 'accepted' then 'accepted' else 'started'
      $('#my-work-story-list').append(pivotal_story_html)
  
  
  populateUpcoming: ->
    _this = @
    upcoming_story_limit = 15
    upcoming_story_count = 0
    @upcoming_stories.map (pivotal_story) ->
      return if upcoming_story_count >= upcoming_story_limit
      upcoming_story_count += 1 unless pivotal_story.current_state is 'accepted'
      pivotal_story_html = pivotal_story_template
        pivotal_story: pivotal_story
        pivotal_story_state_class: if pivotal_story.current_state is 'accepted' then 'accepted' else 'started'
      $('#upcoming-story-list').append(pivotal_story_html)
  
  
  attachStoryClickHandlers: ->
    _this = @
    $('a.pivotal-story').click (e) ->
      _this.focusOnPivotalStory($(@))
  
  
  # Toggle Functions
  
  toggleControlPanelVisibility: ->
    $('#control-panel-container').slideToggle()
    if $('#control-panel-container').is(":visible")
      $('#control-panel-toggle').addClass('active')
    else
      $('#control-panel-toggle').removeClass('active')
  
  
  toggleDoneStoryVisibility: (clicked_button) ->
    console.log clicked_button
  
  
  # Story Control Functions
  
  clearStoryFocus: ->
    $('a.pivotal-story').removeClass('active')
    @focus_pivotal_story = null
    @focus_work_time_units = []
  
  
  redrawFocusedPivotalStory: ->
    _this = @
    return false unless @focus_pivotal_story
    $("a.pivotal-story[data-pivotal-story-id='" + @focus_pivotal_story.id + "']").click()
  
  
  focusOnPivotalStory: (clicked_story) ->
    _this = @
    @clearStoryFocus()
    clicked_story.addClass('active')
    if clicked_story.closest("div").attr("id") is 'my-work-story-list'
      @focus_pivotal_story = _.where(_this.my_work_stories, {id: parseInt(clicked_story.attr('data-pivotal-story-id')) })[0]
    else
      @focus_pivotal_story = _.where(_this.upcoming_stories, {id: parseInt(clicked_story.attr('data-pivotal-story-id')) })[0]
    work_html_unit_html = ''
    clock_story_html = clock_story_template
      pivotal_story: @focus_pivotal_story
    $('#clock-container div.panel div.list-group').empty().append(clock_story_html)
    jsonData =
      work_time_unit:
        pivotal_story_id: @focus_pivotal_story.id
    $.ajax
      type: 'get'
      dataType: 'json'
      data: jsonData
      url: '/work_time_units/'
      success: (data) ->
        data.map (work_time_unit_object) ->
          _this.focus_work_time_units.push(work_time_unit_object)
        _this.focus_work_time_units.map (work_time_unit) ->
          work_html_unit_html += work_time_unit_template
            work_time_unit: work_time_unit
            started_at_formatted: moment(work_time_unit.started_at).format('h:mm a')
            finished_at_formatted: if work_time_unit.finished_at then moment(work_time_unit.finished_at).format('h:mm a') else 'still working'
            total_time_in_seconds_formatted: if work_time_unit.total_time_in_seconds then "(#{work_time_unit.total_time_in_seconds} seconds)" else ''
        $('#work-time-unit-loading-placeholder').replaceWith(work_html_unit_html)
        if _this.focus_work_time_units.length is 0 or _this.focus_work_time_units[_this.focus_work_time_units.length-1].finished_at
          $('#start-work-button').click (e) ->
            _this.startWorkTimeUnit()
            e.preventDefault()
          $('#clock-container').css('height', _this.screen_height)
        else
          stop_work_button_html = stop_work_button_template
          $('#start-work-button').replaceWith(stop_work_button_html)
          $('#stop-work-button').click (e) ->
            _this.stopWorkTimeUnit()
            e.preventDefault()
      error: (jqXHR, textStatus, errorThrown) ->
        console.log "ajax call error: #{errorThrown}"
        $('#work-time-unit-loading-placeholder').html("<p>error loading work time unit records</p>")
  
    
  startWorkTimeUnit: ->
    _this = @
    return false unless @focus_pivotal_story
    started_at_date = new Date()
    jsonData =
      work_time_unit:
        user_id: @me.id
        pivotal_story_id: @focus_pivotal_story.id
        started_at: started_at_date
    $.ajax
      type: 'post'
      dataType: 'json'
      data: jsonData
      url: '/work_time_units/'
      success: (data) ->
        _this.focus_work_time_units.push(data)
        work_html_unit_html = work_time_unit_template
          work_time_unit: data
          started_at_formatted: moment(data.started_at).format('h:mm a')
          finished_at_formatted: 'still working'
          total_time_in_seconds_formatted: ''
        $('#start-work-button').before(work_html_unit_html)
        stop_work_button_html = stop_work_button_template
        $('#start-work-button').replaceWith(stop_work_button_html)
        $('#stop-work-button').click (e) ->
          _this.stopWorkTimeUnit()
          e.preventDefault()
      error: (jqXHR, textStatus, errorThrown) ->
        $('#start-work-button').val("Error: #{errorThrown}")
        console.log "ajax call error: #{errorThrown}"
  
  
  stopWorkTimeUnit: ->
    _this = @
    return false unless @focus_pivotal_story
    last_work_time_unit = @focus_work_time_units[@focus_work_time_units.length-1]
    finished_at_date = new Date()
    jsonData =
      id: last_work_time_unit.id
      work_time_unit:
        finished_at: finished_at_date
    $.ajax
      type: 'patch'
      dataType: 'json'
      data: jsonData
      url: "/work_time_units/#{last_work_time_unit.id}"
      success: (data) ->
        _this.focus_work_time_units[_this.focus_work_time_units.length-1].finished_at = finished_at_date
        _this.redrawFocusedPivotalStory()
      error: (jqXHR, textStatus, errorThrown) ->
        $('#stop-work-button').val("Error: #{errorThrown}")
        console.log "ajax call error: #{errorThrown}"
  
  
  deleteWorkTimeUnit: (work_time_unit_id) ->
    _this = @
    return false unless @focus_pivotal_story
    jsonData =
      id: work_time_unit_id
    $.ajax
      type: 'delete'
      dataType: 'json'
      data: jsonData
      url: "/work_time_units/#{work_time_unit_id}"
      success: (data) ->
        _this.redrawFocusedPivotalStory()
      error: (jqXHR, textStatus, errorThrown) ->
        console.log "ajax call error: #{errorThrown}"
  
  
  
  


ready = ->
  if $('#clock-container').length > 0
    StoryTime.timing = new Timing

$(document).ready(ready)
$(document).on('page:load', ready)
