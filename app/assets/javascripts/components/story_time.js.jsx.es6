import React from 'react';
import ReactDOM from 'react-dom';

class StoryTime extends React.Component {

  constructor() {
    super()
    this.state = {
      userIsAuthenticated: false
    }
  }

  componentWillMount() {
    this.userIsLoggedIn()
  }

  userIsLoggedIn() {
    $.ajax({
      type: "GET",
      url: "/users/me",
      context: this,
      success: () => { this.setState({userIsAuthenticated: true}) }
    });
  }

  componentForRoute() {
    if (this.state.userIsAuthenticated) {
      console.log("user authed")
      console.log(window.location.pathname)
      switch (window.location.pathname) {
        case "/":
          return <Timing />
        case "/reports":
          return <Reports />
        default:
          return <Login />
      }
    } else {
      return <Login />
    }
  }

  render() {
    return this.componentForRoute();
  }
}

window.StoryTime = StoryTime;
