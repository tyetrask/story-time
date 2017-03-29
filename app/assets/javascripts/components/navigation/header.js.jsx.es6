import React from 'react';
import ReactDOM from 'react-dom';
import { Button, Popover, Position, Menu, MenuItem, MenuDivider, Spinner, Tab2, Tabs2 } from '@blueprintjs/core';

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
              <MenuItem text="..." disabled={true} />
            </MenuItem>
            <MenuItem
              text="Toggle Theme"
              onClick={this.props.toggleTheme}
            />
            <MenuItem
              onClick={this.hideCompletedStoriesOnClick}
              text="Hide Completed Stories"
              shouldDismissPopover={false}
              disabled={true}
            />
            <MenuDivider />
            <MenuItem text="Sign Out" iconName="log-out" onClick={this.signOutOnClick} />
           </Menu>
  }

  titleIcon() {
    if (this.props.isLoading) {
      return <Spinner className="pt-super-small" />;
    }
    return <i className='fa fa-book'></i>;
  }

  render() {
    return (<nav className="pt-navbar">
            <div id="navigation-container">
              <div className="pt-navbar-group pt-align-left">
                <div className="pt-navbar-heading">
                  {this.titleIcon()} Story Time
                </div>
              </div>
              <div className="pt-navbar-group pt-align-right">
                <Tabs2 id="tc">
                  <Tab2 id="dw" title={<span><i className='fa fa-fire'></i> Do Work!</span>} />
                  <Tab2 id="rp" title={<span><i className='fa fa-paper-plane-o'></i> Reports</span>} disabled={true} />
                </Tabs2>
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
