import React from 'react';
import ReactDOM from 'react-dom';

class Reports extends React.Component {

  render() {
    return (<div>
            <br />
            <div className="pt-card">
              <p className="text-center">No Accepted Stories This Week.</p>
            </div>
          </div>);
  }
}

window.Reports = Reports;
