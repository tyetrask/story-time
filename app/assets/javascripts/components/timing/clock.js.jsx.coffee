###* @jsx React.DOM ###

window.TimingClock = React.createClass
  
  getInitialState: ->
    {
      work_time_units: [],
      editing_work_time_unit: null
    }
  
  
  componentWillReceiveProps: (nextProps) ->
    _this = @
    @setState({editing_work_time_unit: null})
    if nextProps.selected_story
      $.ajax
        type: 'get'
        dataType: 'json'
        data: {work_time_unit: {pivotal_story_id: nextProps.selected_story.id} }
        url: '/work_time_units/'
        success: (data) ->
          _this.setState({work_time_units: data})
        error: (jqXHR, textStatus, errorThrown) ->
          _this.props.pushNotification("We're sorry. There was an error loading work time units. #{errorThrown}")
  
  
  handleStartWork: ->
    @props.setWorkingStory(@props.selected_story)
    @openWorkTimeUnit()
  
  
  openWorkTimeUnit: ->
    _this = @
    started_at_date = new Date()
    $.ajax
      type: 'post'
      dataType: 'json'
      data: {work_time_unit: {user_id: _this.props.me.id, pivotal_story_id: _this.props.selected_story.id, started_at: started_at_date}}
      url: '/work_time_units/'
      success: (data) ->
        new_work_time_units = _.clone(_this.state.work_time_units)
        new_work_time_units.push(data)
        _this.setState({work_time_units: new_work_time_units})
      error: (jqXHR, textStatus, errorThrown) ->
        _this.props.pushNotification("We're sorry. There was an error creating a work time unit. #{errorThrown}")
        _this.props.setWorkingStory(null)
  
  
  handleStopWork: ->
    @props.setWorkingStory(null)
    @closeWorkTimeUnit()
  
  
  closeWorkTimeUnit: ->
    _this = @
    last_work_time_unit = @state.work_time_units[@state.work_time_units.length-1]
    finished_at_date = new Date()
    $.ajax
      type: 'patch'
      dataType: 'json'
      data: {id: last_work_time_unit.id,work_time_unit: {finished_at: finished_at_date}}
      url: "/work_time_units/#{last_work_time_unit.id}"
      success: (data) ->
        work_time_units = _.clone(_this.state.work_time_units)
        work_time_units.pop()
        work_time_units.push(data)
        _this.setState({work_time_units: work_time_units})
      error: (jqXHR, textStatus, errorThrown) ->
        _this.props.pushNotification("We're sorry. There was an error closing the work time unit. #{errorThrown}")
  
  
  deleteWorkTimeUnit: (work_time_unit) ->
    _this = @
    $.ajax
      type: 'delete'
      dataType: 'json'
      data: {id: work_time_unit.id}
      url: "/work_time_units/#{work_time_unit.id}"
      success: (data) ->
        work_time_units = _.clone(_this.state.work_time_units)
        work_time_units = _.without(work_time_units, work_time_unit)
        _this.setState({work_time_units: work_time_units})
      error: (jqXHR, textStatus, errorThrown) ->
        _this.props.pushNotification("We're sorry. There was an error deleting the work time unit. #{errorThrown}")
  
  
  handleGoToStory: ->
    @props.setSelectedStory(@props.working_story)
  
  
  setEditingWorkTimeUnit: (work_time_unit) ->
    if @state.editing_work_time_unit is work_time_unit
      @setState({editing_work_time_unit: null})
    else
      @setState({editing_work_time_unit: work_time_unit})
  
  
  render: ->
    _this = @
    if @props.selected_story
      work_time_units = []
      @state.work_time_units.map (work_time_unit_object) ->
        work_time_units.push `<TimingClockWorkTimeUnit key={work_time_unit_object.id} work_time_unit={work_time_unit_object} editing_work_time_unit={_this.state.editing_work_time_unit} deleteWorkTimeUnit={_this.deleteWorkTimeUnit} setEditingWorkTimeUnit={_this.setEditingWorkTimeUnit} />`
      labels = []
      @props.selected_story.labels.map (label_object) ->
        labels.push `<span key={label_object.id} className='label label-default'>{label_object.name}</span>`
      if @props.working_story is @props.selected_story
        start_stop_work_button = `<a onClick={_this.handleStopWork} className="list-group-item no-padding"><input type="submit" className="simple" value="Stop Work" /></a>`
      else if @props.working_story
        start_stop_work_button = `<a onClick={_this.handleGoToStory} className="list-group-item no-padding"><input type="submit" className="simple" value="(Go To Currently Open Story)" /></a>`
      else
        start_stop_work_button = `<a onClick={_this.handleStartWork} className="list-group-item no-padding"><input type="submit" className="simple" value="Start Work" /></a>`
      `<div id="clock-container" className="col-xs-6">
         <div className="panel panel-primary">
           <div className="panel-heading text-center">
             Clock
           </div>
           <div className="list-group">
             <a className="list-group-item">
               <p>{this.props.selected_story.name}</p>
               <p><small>{this.props.selected_story.description}</small></p>
               <p>Estimation: {this.props.selected_story.estimate} <span className='pull-right'>{labels}</span></p>
             </a>
             <a className="list-group-item no-padding">
               <input className="simple" placeholder="comment" />
             </a>
             {work_time_units}
             {start_stop_work_button}
           </div>
         </div>
       </div>`
    else
      `<div id="clock-container" className="col-xs-6">
         <div className="panel panel-primary">
           <div className="panel-heading text-center">Clock</div>
           <div className="list-group"></div>
         </div>
       </div>`
