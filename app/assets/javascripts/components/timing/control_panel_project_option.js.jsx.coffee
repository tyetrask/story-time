window.TimingControlPanelProjectOption = React.createClass

  handleProjectSelect: ->
    @props.setSelectedProject(@props.project)


  render: ->
    `<li>
      <a onClick={this.handleProjectSelect}>{this.props.project.name}</a>
     </li>`
