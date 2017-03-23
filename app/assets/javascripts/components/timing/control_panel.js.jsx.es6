import React from 'react';
import ReactDOM from 'react-dom';

class TimingControlPanel extends React.Component {

  completedStoriesToggleText() {
    if (this.props.areCompletedStoriesVisible) {
      return 'Hide';
    }
    return 'Show';
  }

  handleShowCompletedStoriesClick() {
    return this.props.setCompletedStoriesVisibility(!this.props.areCompletedStoriesVisible);
  }

  render() {
    let projectDropdown;
    if (this.props.selectedProject) {
      projectDropdown = <a className="dropdown-toggle" data-toggle="dropdown">Project: {this.props.selectedProject.name} <span className="caret"></span></a>;
    } else {
      projectDropdown = <a className="dropdown-toggle" data-toggle="dropdown">loading projects <span className="caret"></span></a>;
    }
    let projects = this.props.projects.map((project => {
      return (<TimingControlPanelProjectOption
              key={project.id}
              project={project}
              setSelectedProject={this.props.setSelectedProject}
             />);
      }));
    return (<nav id='control-panel-container' className="navbar navbar-default" role="navigation">
            <div className="container-fluid">
              <div className="collapse navbar-collapse">
                <ul className="nav navbar-nav">
                  <li className="dropdown">
                    {projectDropdown}
                    <ul className="dropdown-menu" role="menu">
                      {projects}
                    </ul>
                  </li>
                  <li><a onClick={this.handleShowCompletedStoriesClick.bind(this)}>{this.completedStoriesToggleText()} Completed Stories</a></li>
                </ul>
              </div>
            </div>
          </nav>);
  }
}

window.TimingControlPanel = TimingControlPanel;
