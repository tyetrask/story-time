import React from 'react';
import ReactDOM from 'react-dom';

class Notifications extends React.Component {

  constructor() {
    super()
    this.state = {secondsElapsed: 0};
  }

  tick() {
    if (this.props.notifications.length === 0) { return; }
    if (this.state.secondsElapsed > 7) {
      this.props.dismissNotification();
      return this.setState({secondsElapsed: 0});
    } else {
      return this.setState({secondsElapsed: this.state.secondsElapsed + 1});
    }
  }

  componentDidMount() {
    return this.interval = setInterval(this.tick.bind(this), 1000);
  }

  componentWillUnmount() {
    return clearInterval(this.interval);
  }

  handleDismissNotification() {
    return this.props.dismissNotification();
  }

  notificationClass() {
    if (this.props.notifications.length === 0) { return 'hidden'; }
    return '';
  }

  render() {
    if (this.props.notifications.length > 0) {
      return <div id="notification-container">
         <span onClick={this.handleDismissNotification.bind(this)} className='pull-right'><i className='fa fa-times'></i></span>
         <p className='notification-text'>{this.props.notifications[0]}</p>
       </div>;
    } else {
      return <div id="notification-container" className='hidden'></div>;
    }
  }

}

window.Notifications = Notifications;
