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
