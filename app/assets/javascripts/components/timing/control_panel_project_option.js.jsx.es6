class TimingControlPanelProjectOption extends React.Component {

  handleProjectSelect() {
    return this.props.setSelectedProject(this.props.project);
  }

  render() {
    return (<li>
             <a onClick={this.handleProjectSelect.bind(this)}>
               {this.props.project.name}
             </a>
           </li>);
  }
}

window.TimingControlPanelProjectOption = TimingControlPanelProjectOption;
