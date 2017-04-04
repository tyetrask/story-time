import React from 'react';
import ReactDOM from 'react-dom';

class StoryTime extends React.Component {

  constructor() {
    super()
    this.state = {
      userAuthenticationState: 0, // 0: no attempt, 1: error, 2: authenticated
      theme: 'light'
    }
    let methods = [
      'navigateTo',
      'toggleTheme'
    ]
    methods.forEach((method) => { this[method] = this[method].bind(this); });
  }

  componentWillMount() {
    this.verifyUserAuthenticationState()
  }

  verifyUserAuthenticationState() {
    $.ajax({
      type: "GET",
      url: "/users/current__user",
      context: this,
      success: () => { this.setState({userAuthenticationState: 2}) },
      error: () => { this.setState({userAuthenticationState: 1}) }
    });
  }

  toggleTheme() {
    if (this.state.theme === 'light') {
      this.setState({theme: 'dark'});
    } else {
      this.setState({theme: 'light'})
    }
  }

  containerClass() {
    if (this.state.theme === 'dark') {
      return 'pt-dark';
    }
    return '';
  }

  navigateTo(route) {
    history.pushState(null, 'Story Time', route)
    this.forceUpdate()
  }

  componentForRoute() {
    switch (this.state.userAuthenticationState) {
      case 0:
        return <Empty />;
      case 1:
        return <SignIn />
      case 2:
        switch (window.location.pathname) {
          case "/":
            return <Workspace
                    toggleTheme={this.toggleTheme}
                    navigateTo={this.navigateTo}
                   />
          case "/reports":
            return <Reports />
          case "/users":
            return <ManageUsers />
          case "/profile":
            return <Profile />
          default:
            return <Empty />;
        }
      default:
        return <Empty />;
    }
  }

  render() {
    return <div id="app-container" className={this.containerClass()}>
            {this.componentForRoute()}
           </div>;
  }
}

window.StoryTime = StoryTime;
