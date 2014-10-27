###* @jsx React.DOM ###

window.TimingClockWorkTimeUnit = React.createClass
  
  getInitialState: ->
    {
      started_at_hour_edit: null
      started_at_minute_edit: null
      started_at_ampm_edit: null
      finished_at_hour_edit: null
      finished_at_minute_edit: null
      finished_at_ampm_edit: null
    }
  
  
  handleEditClick: ->
    @setState({
      started_at_hour_edit: moment(this.props.work_time_unit.started_at).format('hh')
      started_at_minute_edit: moment(this.props.work_time_unit.started_at).format('mm')
      started_at_ampm_edit: moment(this.props.work_time_unit.started_at).format('a')
      finished_at_hour_edit: moment(this.props.work_time_unit.finished_at).format('hh')
      finished_at_minute_edit: moment(this.props.work_time_unit.finished_at).format('mm')
      finished_at_ampm_edit: moment(this.props.work_time_unit.finished_at).format('a')
    })
    @props.setEditingWorkTimeUnit(@props.work_time_unit)
  
  
  handleEditStartedAtHourOnChange: (e) ->
    return unless _.contains(['', '0', '1', '01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12'], e.target.value)
    @setState({started_at_hour_edit: e.target.value})
  
  
  handleEditStartedAtMinuteOnChange: (e) ->
    return unless _.contains(['', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30', '31', '32', '33', '34', '35', '36', '37', '38', '39', '40', '41', '42', '43', '44', '45', '46', '47', '48', '49', '50', '51', '52', '53', '54', '55', '56', '57', '58', '59'], e.target.value)
    @setState({started_at_minute_edit: e.target.value})
  
  
  handleEditStartedAtAMPMOnChange: (e) ->
    return unless _.contains(['', 'a', 'am', 'p', 'pm'], e.target.value)
    @setState({started_at_ampm_edit: e.target.value})
  
  
  handleEditFinishedAtHourOnChange: (e) ->
    return unless _.contains(['', '0', '1', '01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12'], e.target.value)
    @setState({finished_at_hour_edit: e.target.value})
  
  
  handleEditFinishedAtMinuteOnChange: (e) ->
    return unless _.contains(['', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30', '31', '32', '33', '34', '35', '36', '37', '38', '39', '40', '41', '42', '43', '44', '45', '46', '47', '48', '49', '50', '51', '52', '53', '54', '55', '56', '57', '58', '59'], e.target.value)
    @setState({finished_at_minute_edit: e.target.value})
  
  
  handleEditFinishedAtAMPMOnChange: (e) ->
    return unless _.contains(['', 'a', 'am', 'p', 'pm'], e.target.value)
    @setState({finished_at_ampm_edit: e.target.value})
  
  
  handleEditSaveClick: ->
    _this = @
    new_started_at = new Date(@props.work_time_unit.started_at)
    new_finished_at = new Date(@props.work_time_unit.finished_at)
    new_started_at.setHours(parseInt(@state.started_at_hour_edit) + (if @state.started_at_ampm_edit is 'pm' then 12 else 0))
    new_started_at_minutes = (if @state.started_at_minute_edit is '' then 0 else parseInt(@state.started_at_minute_edit))
    new_started_at.setMinutes(new_started_at_minutes)
    new_finished_at.setHours(parseInt(@state.finished_at_hour_edit) + (if @state.finished_at_ampm_edit is 'pm' then 12 else 0))
    new_finished_at_minutes = (if @state.finished_at_minute_edit is '' then 0 else parseInt(@state.finished_at_minute_edit))
    new_finished_at.setMinutes(new_finished_at_minutes)
    $.ajax
      type: 'patch'
      dataType: 'json'
      data: {id: _this.props.work_time_unit.id, work_time_unit: {started_at: new_started_at, finished_at: new_finished_at}}
      url: "/work_time_units/#{_this.props.work_time_unit.id}"
      success: (data) ->
        _this.props.updateWorkTimeUnitAfterEdit(_this.props.work_time_unit, new_started_at, new_finished_at, data.total_time_in_seconds)
      error: (jqXHR, textStatus, errorThrown) ->
        _this.props.pushNotification("We're sorry. There was an error saving your update to the work time unit. #{errorThrown}")
    @props.setEditingWorkTimeUnit(null)
    @setState({
      started_at_hour_edit: null
      started_at_minute_edit: null
      started_at_ampm_edit: null
      finished_at_hour_edit: null
      finished_at_minute_edit: null
      finished_at_ampm_edit: null
    })
  
  
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
      editing_html = `<div>
                        <input autoFocus className="simple small" placeholder="hh" onChange={this.handleEditStartedAtHourOnChange} value={this.state.started_at_hour_edit} />
                        <input className="simple small" placeholder="mm" onChange={this.handleEditStartedAtMinuteOnChange} value={this.state.started_at_minute_edit} />
                        <input className="simple small" placeholder="mm" onChange={this.handleEditStartedAtAMPMOnChange} value={this.state.started_at_ampm_edit} />
                        <span className="simple-divider">til</span>
                        <input className="simple small" placeholder="hh" onChange={this.handleEditFinishedAtHourOnChange} value={this.state.finished_at_hour_edit} />
                        <input className="simple small" placeholder="mm" onChange={this.handleEditFinishedAtMinuteOnChange} value={this.state.finished_at_minute_edit} />
                        <input className="simple small" placeholder="mm" onChange={this.handleEditFinishedAtAMPMOnChange} value={this.state.finished_at_ampm_edit} />
                        <input className="simple small" type="submit" value="update" onClick={this.handleEditSaveClick} />
                      </div>`
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
