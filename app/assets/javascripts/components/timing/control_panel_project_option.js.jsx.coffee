###* @jsx React.DOM ###

window.TimingControlPanelProjectOption = React.createClass
  
  handleProjectSelect: (e) ->
    @props.setSelectedProject(@props.project)
  
  
  render: ->
    `<li>
      <a onClick={this.handleProjectSelect}>{this.props.project.name}</a>
     </li>`
