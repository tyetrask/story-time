###* @jsx React.DOM ###

window.TimingUpcoming = React.createClass
  
  getInitialState: ->
    {epic_filter_value: null}
  
  
  handleEpicSelect: (e) ->
    @setState({epic_filter_value: $(e.target).attr('data-epic')})
  
  
  handleClearEpicFilter: ->
    @setState({epic_filter_value: null})
  
  
  filterMenuDisplayText: ->
    if @state.epic_filter_value then "Filter: #{@state.epic_filter_value}" else 'Filter'
  
  render: ->
    _this = @
    epic_options = @props.epic_list.map (epic_name) ->
      epic_key = "epic-#{epic_name}"
      `<li key={epic_key}><a onClick={_this.handleEpicSelect} data-epic={epic_name}>{epic_name}</a></li>`
    stories = @props.upcoming.map (story_object) ->
      if _this.state.epic_filter_value is null or _.find(story_object.labels, {name: _this.state.epic_filter_value})
        `<TimingSharedStory key={story_object.id} story={story_object} selected_story={_this.props.selected_story} setSelectedStory={_this.props.setSelectedStory} completed_stories_visible={_this.props.completed_stories_visible} />`
    `<div className="panel panel-default">
       <div className="panel-heading text-center">
         <strong>Upcoming</strong>
         <div className="dropdown pull-right">
           <a className="dropdown-toggle" data-toggle="dropdown">{this.filterMenuDisplayText()} <b className="caret"></b></a>
           <ul className="dropdown-menu" role="menu">
             <li><a onClick={_this.handleClearEpicFilter}>(Clear Filter)</a></li>
             {epic_options}
           </ul>
         </div>
       </div>
       <div id="upcoming-story-list" className="list-group">
         {stories}
       </div>
     </div>`
