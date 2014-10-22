###* @jsx React.DOM ###

window.TimingLoadingIndicator = React.createClass
  
  getInitialState: ->
    {
      animation_active: false
    }
  
  
  componentDidUpdate: ->
    if @props.is_loading
      @setState({animation_active: true})
    else
      @setState({animation_active: false})
  
  
  loadingClass: ->
    if @props.is_loading
      "la-anim-1 #{@state.animation_active ? 'la-animate' : ''}"
    else
      'la-anim-1 inactive'
  
  
  render: ->
    `<div className={this.loadingClass()}></div>`
