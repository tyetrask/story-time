###* @jsx React.DOM ###

window.TimingClock = React.createClass
  
  getInitialState: ->
    {
      work_time_units: []
    }
  
  
  componentWillReceiveProps: ->
    _this = @
    if @props.selected_story
      $.ajax
        type: 'get'
        dataType: 'json'
        data: {work_time_unit: {pivotal_story_id: _this.props.selected_story.id} }
        url: '/work_time_units/'
        success: (data) ->
          _this.setState({work_time_units: data})
        error: (jqXHR, textStatus, errorThrown) ->
          console.log "ajax call error: #{errorThrown}"
  
  
  render: ->
    if @props.selected_story
      work_time_units = []
      @state.work_time_units.map (work_time_unit_object) ->
        work_time_units.push `<TimingClockWorkTimeUnit key={work_time_unit_object.id} work_time_unit={work_time_unit_object} />`
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
             <a className="list-group-item no-padding">
               <input id="start-work-button" type="submit" className="simple" value="Start Work" />
             </a>
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
