import React from 'react';
import ReactDOM from 'react-dom';
import { Button, Popover, Position, Menu, MenuItem, MenuDivider } from '@blueprintjs/core';

class NavigationHeader extends React.Component {

  changeProjectOnClick(e) {

  }

  hideCompletedStoriesOnClick(e) {

  }

  signOutOnClick(e) {
    $.ajax({
      type: "DELETE",
      url: "/users/sign_out",
      success: () => { window.location.href = "/" }
    });
  }

  settingsMenu() {
    return <Menu>
            <MenuItem text="Change Project">
              <MenuItem text="Project 1" />
              <MenuItem text="Project 2" />
              <MenuItem text="Project 3 TODO" />
            </MenuItem>
            <MenuItem
              onClick={this.hideCompletedStoriesOnClick}
              text="Hide Completed Stories"
              shouldDismissPopover={false}
            />
            <MenuDivider />
            <MenuItem text="Sign Out" iconName="log-out" onClick={this.signOutOnClick} />
           </Menu>
  }

  render() {
    return (<nav className="pt-navbar">
            <div id="navigation-container">
              <div className="pt-navbar-group pt-align-left">
                <div className="pt-navbar-heading">
                  <i className='fa fa-book'></i> StoryTime <small><span id='alpha-label' className='label label-danger'>alpha</span></small>
                </div>
              </div>
              <div className="pt-navbar-group pt-align-right">
                <Button active={true}>
                  <i className='fa fa-fire'></i> Do Work!
                </Button>
                <Button>
                  <i className='fa fa-paper-plane-o'></i> Reports
                </Button>
                <span className="pt-navbar-divider"></span>
                <Popover content={this.settingsMenu()} position={Position.BOTTOM}>
                  <Button iconName="user" />
                </Popover>
              </div>
            </div>
          </nav>);
  }

}

window.NavigationHeader = NavigationHeader;
