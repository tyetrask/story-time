###* @jsx React.DOM ###

window.TimingControlPanel = React.createClass
  
  render: ->
    _this = @
    if @props.selected_project
      project_dropdown = `<a className="dropdown-toggle" data-toggle="dropdown">Project: {this.props.selected_project.name} <span className="caret"></span></a>`
    else
      project_dropdown = `<a className="dropdown-toggle" data-toggle="dropdown">loading projects <span className="caret"></span></a>`
    projects = []
    @props.projects.map (project_object) ->
      projects.push `<TimingControlPanelProjectOption key={project_object.id} project={project_object} setSelectedProject={_this.props.setSelectedProject} />`
    `<nav id='control-panel-container' className="navbar navbar-default" role="navigation">
      <div className="container-fluid">
        <div className="collapse navbar-collapse">
          
          <ul className="nav navbar-nav">
            <li className="dropdown">
              {project_dropdown}
              <ul className="dropdown-menu" role="menu">
                {projects}
              </ul>
            </li>
          </ul>
        
        </div>
      </div>
    </nav>`
