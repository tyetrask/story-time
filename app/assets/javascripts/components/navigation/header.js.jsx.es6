import React from 'react';
import ReactDOM from 'react-dom';

class NavigationHeader extends React.Component {

  render() {
    return (<nav className="pt-navbar">
            <div style={{margin: '0 9%'}}>
              <div className="pt-navbar-group pt-align-left">
                <div className="pt-navbar-heading">
                  <i className='fa fa-book'></i> StoryTime <small><span id='alpha-label' className='label label-danger'>alpha</span></small>
                </div>
              </div>
              <div className="pt-navbar-group pt-align-right">
                <button className="pt-button pt-minimal pt-active">
                  <i className='fa fa-fire'></i> Do Work!
                </button>
                <button className="pt-button pt-minimal">
                  <i className='fa fa-paper-plane-o'></i> Reports
                </button>
                <span className="pt-navbar-divider"></span>
                <button className="pt-button pt-minimal pt-icon-cog"></button>
                <button className="pt-button pt-minimal pt-icon-user"></button>
              </div>
            </div>
          </nav>);
  }

}

window.NavigationHeader = NavigationHeader;
