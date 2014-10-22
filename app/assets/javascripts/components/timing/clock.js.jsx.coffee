###* @jsx React.DOM ###

window.TimingClock = React.createClass
  
  getInitialState: ->
    {
      work_time_units: []
    }
  
  
  componentWillReceiveProps: (nextProps) ->
    _this = @
    if nextProps.selected_story
      $.ajax
        type: 'get'
        dataType: 'json'
        data: {work_time_unit: {pivotal_story_id: nextProps.selected_story.id} }
        url: '/work_time_units/'
        success: (data) ->
          _this.setState({work_time_units: data})
        error: (jqXHR, textStatus, errorThrown) ->
          console.log "ajax call error: #{errorThrown}"
  
  
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
        console.log "ajax call error: #{errorThrown}"
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
        _this.focus_work_time_units[_this.focus_work_time_units.length-1].finished_at = finished_at_date
        work_time_units = _.clone(_this.state.work_time_units)
        work_time_units[work_time_units.length-1].finished_at = finished_at_date
        _this.setState({work_time_units: work_time_units})
      error: (jqXHR, textStatus, errorThrown) ->
        console.log "ajax call error: #{errorThrown}"
  
  
  
  render: ->
    _this = @
    if @props.selected_story
      work_time_units = []
      @state.work_time_units.map (work_time_unit_object) ->
        work_time_units.push `<TimingClockWorkTimeUnit key={work_time_unit_object.id} work_time_unit={work_time_unit_object} />`
      if @props.working_story is @props.selected_story
        start_stop_work_button = `<a onClick={_this.handleStopWork} className="list-group-item no-padding"><input type="submit" className="simple" value="Stop Work" /></a>`
      else if @props.working_story
        start_stop_work_button = `<a className="list-group-item no-padding"><input type="submit" className="simple" value="(Please Stop Work On Other Story)" /></a>`
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
               <p>Estimation: {this.props.selected_story.estimate}</p>
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
