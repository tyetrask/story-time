###* @jsx React.DOM ###

window.TimingClockWorkTimeUnit = React.createClass
  
  handleEditClick: ->
    console.log 'edit!'
  
  
  handleDeleteClick: ->
    console.log 'delete!'
    _this = @
    return false # TODO: implement.
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
  
  
  startWorkTimeUnit: ->
    _this = @
    return false # TODO: implement.
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
    return false # TODO: implement.
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
  
  
  startedAtFormatted: ->
    moment(@props.work_time_unit.started_at).format('h:mm a')
  
  
  finishedAtFormatted: ->
    moment(@props.work_time_unit.finished_at).format('h:mm a')
  
  
  totalTimeInSecondsFormatted: ->
    if @props.work_time_unit.total_time_in_seconds > 3600
      "(#{@roundNumber((@props.work_time_unit.total_time_in_seconds / 60 / 60))} hours)"
    else if @props.work_time_unit.total_time_in_seconds > 90
      "(#{@roundNumber((@props.work_time_unit.total_time_in_seconds / 60))} minutes)"
    else if @props.work_time_unit.total_time_in_seconds > 0
      "(#{@roundNumber((@props.work_time_unit.total_time_in_seconds))} seconds)"
    else
      ""
  
  
  roundNumber: (number) ->
    Math.round( number * 10) / 10
  
  
  render: ->
    `<a className='list-group-item work-time-unit'>
      <p><i onClick={this.handleEditClick} className='fa fa-pencil'></i> <i onClick={this.handleDeleteClick} className='fa fa-trash'></i> Developer: {this.props.work_time_unit.user_id}
        <span className='pull-right'>
          {this.startedAtFormatted()} - {this.finishedAtFormatted()} <small>{this.totalTimeInSecondsFormatted()}</small>
        </span>
      </p>
    </a>`
