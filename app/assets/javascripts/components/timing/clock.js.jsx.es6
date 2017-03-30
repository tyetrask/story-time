import React from 'react';
import ReactDOM from 'react-dom';
import { NonIdealState, Tag, Intent } from '@blueprintjs/core'
var _ = require('lodash');

class TimingClock extends React.Component {

  constructor() {
    super()
    this.state = {
      workTimeUnits: [],
      editingWorkTimeUnit: null
    };
    let methodsToBind = [
      'setEditingWorkTimeUnit',
      'deleteWorkTimeUnit',
      'updateWorkTimeUnitAfterEdit'
    ]
    methodsToBind.forEach((method) => { this[method] = this[method].bind(this); });
  }

  componentWillReceiveProps(nextProps) {
    this.setState({editingWorkTimeUnit: null});
    if (nextProps.selectedStoryID === null) { return; }
    if (this.props.selectedStoryID != nextProps.selectedStoryID) {
      this.setState({workTimeUnits: []}, this.loadWorkTimeUnits.bind(this, nextProps))
    }
  }

  loadWorkTimeUnits(nextProps) {
    $.ajax({
      type: 'get',
      dataType: 'json',
      data: {work_time_unit: {project_id: nextProps.selectedProjectID, story_id: nextProps.selectedStoryID} },
      url: '/work_time_units',
      context: this,
      success(data) {
        return this.setState({workTimeUnits: data});
      },
      error(jqXHR, textStatus, errorThrown) {
        return this.props.pushNotification({
          message: `We're sorry. There was an error loading work time units. ${errorThrown}`,
          intent: Intent.DANGER
        });
      }
    });
  }

  handleStartWork() {
    this.props.setWorkingStoryID(this.props.selectedStoryID);
    return this.createWorkTimeUnit();
  }

  createWorkTimeUnit() {
    let startedAt = new Date();
    return $.ajax({
      type: 'post',
      dataType: 'json',
      data: {
        work_time_unit: {
          integration_id: this.props.selectedIntegrationID,
          integration_user_id: this.props.currentUserExternal.id,
          project_id: this.props.selectedProjectID,
          story_id: this.props.selectedStoryID,
          started_at: startedAt
        }
      },
      url: '/work_time_units',
      context: this,
      success(data) {
        let newWorkTimeUnits = _.clone(this.state.workTimeUnits);
        newWorkTimeUnits.push(data);
        return this.setState({workTimeUnits: newWorkTimeUnits}, this.updateStoryStateIfNeeded);
      },
      error(jqXHR, textStatus, errorThrown) {
        this.props.pushNotification({
          message: `We're sorry. There was an error creating a work time unit. ${errorThrown}`,
          intent: Intent.DANGER
        });
        return this.props.setWorkingStoryID(null);
      }
    });
  }

  updateStoryStateIfNeeded() {
    let story = _.find(this.props.stories, {id: this.props.selectedStoryID})
    if (story && story.current_state === 'unstarted') {
      this.props.updateStoryState(this.props.selectedStoryID, 'started');
    }
  }

  handleStopWork() {
    this.props.setWorkingStoryID(null);
    return this.closeWorkTimeUnit();
  }

  closeWorkTimeUnit() {
    let lastWorkTimeUnit = this.state.workTimeUnits[this.state.workTimeUnits.length-1];
    let finishedAt = new Date();
    return $.ajax({
      type: 'patch',
      dataType: 'json',
      data: {id: lastWorkTimeUnit.id, work_time_unit: {finished_at: finishedAt}},
      url: `/work_time_units/${lastWorkTimeUnit.id}`,
      context: this,
      success(data) {
        let workTimeUnits = _.clone(this.state.workTimeUnits);
        workTimeUnits.pop();
        workTimeUnits.push(data);
        return this.setState({workTimeUnits});
      },
      error(jqXHR, textStatus, errorThrown) {
        return this.props.pushNotification({
          message: `We're sorry. There was an error closing the work time unit. ${errorThrown}`,
          intent: Intent.DANGER
        });
      }
    });
  }

  deleteWorkTimeUnit(workTimeUnit) {
    return $.ajax({
      type: 'delete',
      dataType: 'json',
      data: {id: workTimeUnit.id},
      url: `/work_time_units/${workTimeUnit.id}`,
      context: this,
      success(data) {
        let workTimeUnits = _.clone(this.state.workTimeUnits);
        workTimeUnits = _.without(workTimeUnits, workTimeUnit);
        return this.setState({workTimeUnits});
      },
      error(jqXHR, textStatus, errorThrown) {
        return this.props.pushNotification({
          message: `We're sorry. There was an error deleting the work time unit. ${errorThrown}`,
          intent: Intent.DANGER
        });
      }
    });
  }

  handleGoToStory() {
    return this.props.setSelectedStoryID(this.props.workingStoryID);
  }

  setEditingWorkTimeUnit(workTimeUnit) {
    if (this.state.editingWorkTimeUnit === workTimeUnit) {
      return this.setState({editingWorkTimeUnit: null});
    } else {
      return this.setState({editingWorkTimeUnit: workTimeUnit});
    }
  }

  updateWorkTimeUnitAfterEdit(workTimeUnit, newStartedAt, newFinishedAt, newTotalTimeInSeconds) {
    let workTimeUnits = _.clone(this.state.workTimeUnits);
    let workTimeUnitToUpdate = _.find(workTimeUnits, {id: workTimeUnit.id});
    workTimeUnitToUpdate.started_at = newStartedAt;
    workTimeUnitToUpdate.finished_at = newFinishedAt;
    workTimeUnitToUpdate.total_time_in_seconds = newTotalTimeInSeconds;
    return this.setState({workTimeUnits});
  }

  render() {
    let selectedStory;
    if (this.props.selectedStoryID) {
      selectedStory = _.find(this.props.stories, {id: this.props.selectedStoryID})
    }
    if (selectedStory) {
      let startStopWorkButton;
      let workTimeUnits = [];
      this.state.workTimeUnits.map((workTimeUnit => {
        return workTimeUnits.push(<TimingClockWorkTimeUnit
                                    key={workTimeUnit.id}
                                    workTimeUnit={workTimeUnit}
                                    editingWorkTimeUnit={this.state.editingWorkTimeUnit}
                                    deleteWorkTimeUnit={this.deleteWorkTimeUnit}
                                    setEditingWorkTimeUnit={this.setEditingWorkTimeUnit}
                                    updateWorkTimeUnitAfterEdit={this.updateWorkTimeUnitAfterEdit}
                                    pushNotification={this.props.pushNotification}
                                  />);
        }));
      let labels = selectedStory.labels.map(label => <Tag key={label.id}>{label.name}</Tag>);
      if (this.props.workingStoryID === this.props.selectedStoryID) {
        startStopWorkButton = <a onClick={this.handleStopWork.bind(this)} className="pt-button pt-fill">
                                Stop Work
                              </a>;
      } else if (this.props.workingStoryID) {
        startStopWorkButton = <a onClick={this.handleGoToStory.bind(this)} className="pt-button pt-fill">
                                (Go To Currently Open Story)
                              </a>;
      } else {
        startStopWorkButton = <a onClick={this.handleStartWork.bind(this)} className="pt-button pt-fill">
                                Start Work
                              </a>;
      }
      return (<div key="clock-full" id="clock-container">
               <div>
                 <div className="pt-card pt-elevation-2">
                   <h5>{selectedStory.name}</h5>
                   <p>{selectedStory.description}</p>
                   <p>Estimation: {selectedStory.estimate} <span className='pull-right'>{labels}</span></p>
                   <br />
                   {workTimeUnits}
                   <br />
                   {startStopWorkButton}
                 </div>
               </div>
             </div>);
    }
    return <div key="clock-empty" id="clock-container">
            <div>
              <div className="pt-card pt-elevation-0">
                <br /><br /><br /><br />
                <NonIdealState
                 title="No Story Selected"
                 description="Please select a story to begin working"
                 visual="pt-icon-build"
                />
                <br /><br /><br /><br /><br />
              </div>
            </div>

           </div>
  }
}

window.TimingClock = TimingClock;
