window.Notifications = React.createClass

  getInitialState: ->
    {seconds_elapsed: 0}


  tick: ->
    return if @props.notifications.length is 0
    if @state.seconds_elapsed > 7
      @props.dismissNotification()
      @setState({seconds_elapsed: 0})
    else
      @setState({seconds_elapsed: @state.seconds_elapsed + 1})


  componentDidMount: ->
    @interval = setInterval(@tick, 1000)


  componentWillUnmount: ->
    clearInterval(this.interval)


  handleDismissNotification: ->
    @props.dismissNotification()


  notificationClass: ->
    return 'hidden' if @props.notifications.length is 0
    ''


  render: ->
    if @props.notifications.length > 0
      `<div id="notification-container">
         <span onClick={this.handleDismissNotification} className='pull-right'><i className='fa fa-times'></i></span>
         <p className='notification-text'>{this.props.notifications[0]}</p>
       </div>`
    else
      `<div id="notification-container" className='hidden'></div>`
