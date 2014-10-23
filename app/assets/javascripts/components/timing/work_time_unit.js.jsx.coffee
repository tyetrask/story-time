###* @jsx React.DOM ###

window.TimingClockWorkTimeUnit = React.createClass
  
  handleEditClick: ->
    @props.setEditingWorkTimeUnit(@props.work_time_unit)
  
  
  handleEditSaveClick: ->
    console.log 'save this!'
  
  
  handleDeleteClick: ->
    @props.deleteWorkTimeUnit(@props.work_time_unit)
  
  
  startedAtFormatted: ->
    moment(@props.work_time_unit.started_at).format('h:mm a')
  
  
  finishedAtFormatted: ->
    if @props.work_time_unit.finished_at
      moment(@props.work_time_unit.finished_at).format('h:mm a')
    else
      'still working'
  
  
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
    if @props.work_time_unit is @props.editing_work_time_unit
      editing_html = `<p>Editing Controls Go Here!</p>`
    else
      editing_html = null
    `<a className='list-group-item work-time-unit'>
      <p><i onClick={this.handleEditClick} className='fa fa-pencil'></i> <i onClick={this.handleDeleteClick} className='fa fa-trash'></i> Developer: {this.props.work_time_unit.user_id}
        <span className='pull-right'>
          {this.startedAtFormatted()} - {this.finishedAtFormatted()} <small>{this.totalTimeInSecondsFormatted()}</small>
        </span>
      </p>
      {editing_html}
    </a>`
