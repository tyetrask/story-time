window.TimingClockWorkTimeUnit = React.createClass

  getInitialState: ->
    {
      date_month_edit: null
      date_day_edit: null
      date_year_edit: null
      started_at_hour_edit: null
      started_at_minute_edit: null
      started_at_ampm_edit: null
      finished_at_hour_edit: null
      finished_at_minute_edit: null
      finished_at_ampm_edit: null
    }


  handleEditClick: ->
    return if not @props.work_time_unit.finished_at
    @setState({
      date_month_edit: moment(this.props.work_time_unit.started_at).format('MM')
      date_day_edit: moment(this.props.work_time_unit.started_at).format('DD')
      date_year_edit: moment(this.props.work_time_unit.started_at).format('YYYY')
      started_at_hour_edit: moment(this.props.work_time_unit.started_at).format('hh')
      started_at_minute_edit: moment(this.props.work_time_unit.started_at).format('mm')
      started_at_ampm_edit: moment(this.props.work_time_unit.started_at).format('a')
      finished_at_hour_edit: moment(this.props.work_time_unit.finished_at).format('hh')
      finished_at_minute_edit: moment(this.props.work_time_unit.finished_at).format('mm')
      finished_at_ampm_edit: moment(this.props.work_time_unit.finished_at).format('a')
    })
    @props.setEditingWorkTimeUnit(@props.work_time_unit)


  handleEditDateMonthOnChange: (e) ->
    return unless _.contains(['', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'], e.target.value)
    @setState({date_month_edit: e.target.value})


  handleEditDateDayOnChange: (e) ->
    return unless _.contains(['', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30', '31'], e.target.value)
    @setState({date_day_edit: e.target.value})


  handleEditDateYearOnChange: (e) ->
    return unless _.contains(['201', '2014', '2015', '2016', '2017', '2018', '2019'], e.target.value)
    @setState({date_year_edit: e.target.value})


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
    month = parseInt(@state.date_month_edit) - 1
    day = parseInt(@state.date_day_edit)
    year = parseInt(@state.date_year_edit)
    new_started_at = new Date(@props.work_time_unit.started_at)
    new_finished_at = new Date(@props.work_time_unit.finished_at)
    new_started_at.setFullYear(year, month, day)
    new_finished_at.setFullYear(year, month, day)
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
      date_month_edit: null
      date_day_edit: null
      date_year_edit: null
      started_at_hour_edit: null
      started_at_minute_edit: null
      started_at_ampm_edit: null
      finished_at_hour_edit: null
      finished_at_minute_edit: null
      finished_at_ampm_edit: null
    })


  handleDeleteClick: ->
    return if not @props.work_time_unit.finished_at
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


  buttonClass: (button_type) ->
    css_class = 'fa'
    css_class += ' fa-pencil' if button_type is 'edit'
    css_class += ' fa-trash' if button_type is 'delete'
    css_class += ' disabled' if not @props.work_time_unit.finished_at
    css_class


  render: ->
    if @props.work_time_unit is @props.editing_work_time_unit
      editing_html = `<div>
                        <div>
                          <input className="simple small" placeholder="mm" onChange={this.handleEditDateMonthOnChange} value={this.state.date_month_edit} />
                          <input className="simple small" placeholder="dd" onChange={this.handleEditDateDayOnChange} value={this.state.date_day_edit} />
                          <input className="simple small" placeholder="yyyy" onChange={this.handleEditDateYearOnChange} value={this.state.date_year_edit} />
                        </div>
                        <div>
                          <input autoFocus className="simple small" placeholder="hh" onChange={this.handleEditStartedAtHourOnChange} value={this.state.started_at_hour_edit} />
                          <input className="simple small" placeholder="mm" onChange={this.handleEditStartedAtMinuteOnChange} value={this.state.started_at_minute_edit} />
                          <input className="simple small" placeholder="mm" onChange={this.handleEditStartedAtAMPMOnChange} value={this.state.started_at_ampm_edit} />
                          <span className="simple-divider">til</span>
                          <input className="simple small" placeholder="hh" onChange={this.handleEditFinishedAtHourOnChange} value={this.state.finished_at_hour_edit} />
                          <input className="simple small" placeholder="mm" onChange={this.handleEditFinishedAtMinuteOnChange} value={this.state.finished_at_minute_edit} />
                          <input className="simple small" placeholder="mm" onChange={this.handleEditFinishedAtAMPMOnChange} value={this.state.finished_at_ampm_edit} />
                          <input className="simple small" type="submit" value="update" onClick={this.handleEditSaveClick} />
                        </div>
                      </div>`
    else
      editing_html = null
    `<a className='list-group-item work-time-unit'>
      <p><i onClick={this.handleEditClick} className={this.buttonClass('edit')}></i> <i onClick={this.handleDeleteClick} className={this.buttonClass('delete')}></i> Developer: {this.props.work_time_unit.user_id}
        <span className='pull-right'>
          {this.startedAtFormatted()} - {this.finishedAtFormatted()} <small>{this.totalTimeInSecondsFormatted()}</small>
        </span>
      </p>
      {editing_html}
    </a>`
