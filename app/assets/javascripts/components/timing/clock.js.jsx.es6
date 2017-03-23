import React from 'react';
import ReactDOM from 'react-dom';

class TimingClock extends React.Component {

  constructor() {
    super()
    this.state = {
      workTimeUnits: [],
      editingWorkTimeUnit: null
    };
    let methods = [
      'setEditingWorkTimeUnit',
      'deleteWorkTimeUnit',
      'updateWorkTimeUnitAfterEdit'
    ]
    methods.forEach((method) => { this[method] = this[method].bind(this); });
  }

  componentWillReceiveProps(nextProps) {
    this.setState({editingWorkTimeUnit: null});
    if (this.props.selectedStory != nextProps.selectedStory) {
      return $.ajax({
        type: 'get',
        dataType: 'json',
        data: {work_time_unit: {project_id: nextProps.selectedProject.id, story_id: nextProps.selectedStory.id} },
        url: '/work_time_units/',
        context: this,
        success(data) {
          return this.setState({workTimeUnits: data});
        },
        error(jqXHR, textStatus, errorThrown) {
          return this.props.pushNotification(`We're sorry. There was an error loading work time units. ${errorThrown}`);
        }
      });
    }
  }

  handleStartWork() {
    this.props.setWorkingStory(this.props.selectedStory);
    return this.openWorkTimeUnit();
  }

  openWorkTimeUnit() {
    let startedAt = new Date();
    return $.ajax({
      type: 'post',
      dataType: 'json',
      data: {work_time_unit: {user_id: this.props.meExternal.id, project_id: this.props.selectedProject.id, story_id: this.props.selectedStory.id, started_at: startedAt}},
      url: '/work_time_units/',
      context: this,
      success(data) {
        let newWorkTimeUnits = _.clone(this.state.workTimeUnits);
        newWorkTimeUnits.push(data);
        return this.setState({workTimeUnits: newWorkTimeUnits});
      },
      error(jqXHR, textStatus, errorThrown) {
        this.props.pushNotification(`We're sorry. There was an error creating a work time unit. ${errorThrown}`);
        return this.props.setWorkingStory(null);
      }
    });
  }

  handleStopWork() {
    this.props.setWorkingStory(null);
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
        return this.props.pushNotification(`We're sorry. There was an error closing the work time unit. ${errorThrown}`);
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
        return this.props.pushNotification(`We're sorry. There was an error deleting the work time unit. ${errorThrown}`);
      }
    });
  }

  handleGoToStory() {
    return this.props.setSelectedStory(this.props.workingStory);
  }

  handleChangeStoryState() {
    return this.props.updateStoryState(this.props.selectedStory, 'started');
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
    if (this.props.selectedStory) {
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
      let labels = this.props.selectedStory.labels.map(label => <span key={label.id} className='label label-default'>{label.name}</span>);
      if (this.props.workingStory === this.props.selectedStory) {
        startStopWorkButton = <a onClick={this.handleStopWork.bind(this)} className="list-group-item no-padding">
                                <input type="submit" className="simple" value="Stop Work" />
                              </a>;
      } else if (this.props.workingStory) {
        startStopWorkButton = <a onClick={this.handleGoToStory.bind(this)} className="list-group-item no-padding">
                                <input type="submit" className="simple" value="(Go To Currently Open Story)" />
                              </a>;
      } else {
        startStopWorkButton = <a onClick={this.handleStartWork.bind(this)} className="list-group-item no-padding">
                                <input type="submit" className="simple" value="Start Work" />
                              </a>;
      }
      return (<div key="clock-container-full" id="clock-container" className="col-xs-6">
               <div className="panel panel-primary">
                 <div className="panel-heading text-center">
                   Clock
                 </div>
                 <div className="list-group">
                   <a className="list-group-item">
                     <p>{this.props.selectedStory.name}</p>
                     <p><small>{this.props.selectedStory.description}</small></p>
                     <p>Estimation: {this.props.selectedStory.estimate} <span className='pull-right'>{labels}</span></p>
                   </a>
                   <a className="list-group-item no-padding">
                     <input className="simple" placeholder="comment" />
                   </a>
                   {workTimeUnits}
                   {startStopWorkButton}
                 </div>
               </div>
             </div>);
    } else {
      return (<div key="clock-container-empty" id="clock-container" className="col-xs-6">
               <div className="panel panel-primary">
                 <div className="panel-heading text-center">Clock</div>
                 <div className="list-group"></div>
               </div>
             </div>);
    }
  }
}

window.TimingClock = TimingClock;
