class Timing
  
  me: null
  my_work_stories: []
  upcoming_stories: []
  
  focus_pivotal_story: null
  focus_work_time_units: []
  
  pivotal_story_template = _.template("<a data-pivotal-story-id='<%= pivotal_story['id'] %>' class='list-group-item pivotal-story <%= pivotal_story_state_class %>'><span class='pull-right'><i class='fa fa-clock-o'></i> <%= pivotal_story['estimate'] %></span><p><%= pivotal_story['name'] %></p></a>")
  clock_story_template = _.template("<a class='list-group-item'><p><%= pivotal_story['name'] %></p><p><%= pivotal_story['description'] %></p><p>Estimation: <%= pivotal_story['estimate'] %></p></a><a class='list-group-item no-padding'><input class='simple' placeholder='comment'/></a><a id='work-time-unit-loading-placeholder' class='list-group-item'><p>loading work records <i class='fa fa-refresh fa-spin'></i></p></a><a class='list-group-item no-padding'><input type='submit' class='simple' value='Start Work'/></a>")
  work_time_unit_template = _.template("<a class='list-group-item work-time-unit'><p>Developer: <%= work_time_unit.user_id %><span class='pull-right'><span class='time-range'><%= work_time_unit.started_at %> - <%= work_time_unit.finished_at %></span><%= work_time_unit.total_time_in_seconds %></span></p></a>")
  
  constructor: ->
    _this = @
    
    @me = null
    @my_work_stories = []
    @upcoming_stories = []
    @focus_pivotal_story = null
    @focus_work_time_units = []
    
    @setSizeOfStoryContainer()
    @populateProjectsList()
    @loadPivotalData()
    $('#control-panel-toggle a').click (e) ->
      _this.toggleControlPanelVisibility()
  
  
  # Setup Functions
  
  setSizeOfStoryContainer: ->
    window_height = $(window).height()
    navigation_height = $('#navigation-container').height()
    $('#stories-container').css('height', (window_height - navigation_height))
  
  
  # Load Functions
  
  populateProjectsList: ->
    [].map (project_object) ->
      $('#project-list').append("<li><a>#{project_object['name']}</a></li>")
  
  
  loadPivotalData: ->
    _this = @
    $.ajax
      type: 'get'
      dataType: 'json'
      url: '/timing/index'
      success: (data) ->
        _this.me = data.me
        data.my_work.map (pivotal_story) ->
          _this.my_work_stories.push(pivotal_story)
        data.pivotal_iterations.map (iteration) ->
          iteration['stories'].map (pivotal_story) ->
            _this.upcoming_stories.push(pivotal_story)
        _this.populateMyWork()
        _this.populateUpcoming()
        _this.attackStoryClickHandlers()
      error: (jqXHR, textStatus, errorThrown) ->
        console.log "ajax call error: #{errorThrown}"
  
  
  # Initial Display Functions
  
  populateMyWork: ->
    _this = @
    @my_work_stories.map (pivotal_story) ->
      pivotal_story_html = pivotal_story_template
        pivotal_story: pivotal_story
        pivotal_story_state_class: if pivotal_story['current_state'] is 'accepted' then 'accepted' else 'started'
      $('#my-work-story-list').append(pivotal_story_html)
  
  
  populateUpcoming: ->
    _this = @
    upcoming_story_limit = 15
    upcoming_story_count = 0
    @upcoming_stories.map (pivotal_story) ->
      return if upcoming_story_count >= upcoming_story_limit
      upcoming_story_count += 1 unless pivotal_story['current_state'] is 'accepted'
      pivotal_story_html = pivotal_story_template
        pivotal_story: pivotal_story
        pivotal_story_state_class: if pivotal_story['current_state'] is 'accepted' then 'accepted' else 'started'
      $('#upcoming-story-list').append(pivotal_story_html)
  
  
  attackStoryClickHandlers: ->
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
  
  
  focusOnPivotalStory: (clicked_story) ->
    _this = @
    @clearStoryFocus()
    clicked_story.addClass('active')
    if clicked_story.closest("div").attr("id") is 'my-work-story-list'
      pivotal_story = _.where(_this.my_work_stories, {id: parseInt(clicked_story.attr('data-pivotal-story-id')) })[0]
    else
      pivotal_story = _.where(_this.upcoming_stories, {id: parseInt(clicked_story.attr('data-pivotal-story-id')) })[0]
    work_html_unit_html = ''
    clock_story_html = clock_story_template
      pivotal_story: pivotal_story
    $('#clock-container div.panel div.list-group').empty().append(clock_story_html)
    jsonData =
      work_time_unit:
        pivotal_story_id: pivotal_story['id']
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
        $('#work-time-unit-loading-placeholder').replaceWith(work_html_unit_html)
      error: (jqXHR, textStatus, errorThrown) ->
        console.log "ajax call error: #{errorThrown}"
        $('#work-time-unit-loading-placeholder').html("<p>error loading work time unit records</p>")
  
  


ready = ->
  if $('#clock-container').length > 0
    StoryTime.timing = new Timing

$(document).ready(ready)
$(document).on('page:load', ready)
