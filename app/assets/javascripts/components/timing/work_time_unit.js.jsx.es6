import React from 'react';
import ReactDOM from 'react-dom';

class TimingClockWorkTimeUnit extends React.Component {

  constructor() {
    super()
    this.state = {
      dateMonthFormValue: null,
      dateDayFormValue: null,
      dateYearFormValue: null,
      startedAtHourFormValue: null,
      startedAtMinuteFormValue: null,
      startedAtAMPMFormValue: null,
      finishedAtHourFormValue: null,
      finishedAtMinuteFormValue: null,
      finishedAtAMPMFormValue: null
    };
    let methods = [
      'handleEditClick',
      'handleEditSaveClick',
      'handleDeleteClick',
      'handleEditDateMonthOnChange',
      'handleEditDateDayOnChange',
      'handleEditDateYearOnChange',
      'handleEditStartedAtHourOnChange',
      'handleEditStartedAtMinuteOnChange',
      'handleEditStartedAtAMPMOnChange',
      'handleEditFinishedAtHourOnChange',
      'handleEditFinishedAtMinuteOnChange',
      'handleEditFinishedAtAMPMOnChange'
    ]
    methods.forEach((method) => { this[method] = this[method].bind(this); });
  }

  handleEditClick() {
    if (!this.props.workTimeUnit.finished_at) { return; }
    this.setState({
      dateMonthFormValue: moment(this.props.workTimeUnit.started_at).format('MM'),
      dateDayFormValue: moment(this.props.workTimeUnit.started_at).format('DD'),
      dateYearFormValue: moment(this.props.workTimeUnit.started_at).format('YYYY'),
      startedAtHourFormValue: moment(this.props.workTimeUnit.started_at).format('hh'),
      startedAtMinuteFormValue: moment(this.props.workTimeUnit.started_at).format('mm'),
      startedAtAMPMFormValue: moment(this.props.workTimeUnit.started_at).format('a'),
      finishedAtHourFormValue: moment(this.props.workTimeUnit.finished_at).format('hh'),
      finishedAtMinuteFormValue: moment(this.props.workTimeUnit.finished_at).format('mm'),
      finishedAtAMPMFormValue: moment(this.props.workTimeUnit.finished_at).format('a')
    });
    return this.props.setEditingWorkTimeUnit(this.props.workTimeUnit);
  }

  handleEditDateMonthOnChange(e) {
    if (!_.contains(['', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'], e.target.value)) { return; }
    return this.setState({dateMonthFormValue: e.target.value});
  }

  handleEditDateDayOnChange(e) {
    if (!_.contains(['', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30', '31'], e.target.value)) { return; }
    return this.setState({dateDayFormValue: e.target.value});
  }

  handleEditDateYearOnChange(e) {
    if (!_.contains(['201', '2014', '2015', '2016', '2017', '2018', '2019'], e.target.value)) { return; }
    return this.setState({dateYearFormValue: e.target.value});
  }

  handleEditStartedAtHourOnChange(e) {
    if (!_.contains(['', '0', '1', '01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12'], e.target.value)) { return; }
    return this.setState({startedAtHourFormValue: e.target.value});
  }

  handleEditStartedAtMinuteOnChange(e) {
    if (!_.contains(['', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30', '31', '32', '33', '34', '35', '36', '37', '38', '39', '40', '41', '42', '43', '44', '45', '46', '47', '48', '49', '50', '51', '52', '53', '54', '55', '56', '57', '58', '59'], e.target.value)) { return; }
    return this.setState({startedAtMinuteFormValue: e.target.value});
  }

  handleEditStartedAtAMPMOnChange(e) {
    if (!_.contains(['', 'a', 'am', 'p', 'pm'], e.target.value)) { return; }
    return this.setState({startedAtAMPMFormValue: e.target.value});
  }

  handleEditFinishedAtHourOnChange(e) {
    if (!_.contains(['', '0', '1', '01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12'], e.target.value)) { return; }
    return this.setState({finishedAtHourFormValue: e.target.value});
  }

  handleEditFinishedAtMinuteOnChange(e) {
    if (!_.contains(['', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30', '31', '32', '33', '34', '35', '36', '37', '38', '39', '40', '41', '42', '43', '44', '45', '46', '47', '48', '49', '50', '51', '52', '53', '54', '55', '56', '57', '58', '59'], e.target.value)) { return; }
    return this.setState({finishedAtMinuteFormValue: e.target.value});
  }

  handleEditFinishedAtAMPMOnChange(e) {
    if (!_.contains(['', 'a', 'am', 'p', 'pm'], e.target.value)) { return; }
    return this.setState({finishedAtAMPMFormValue: e.target.value});
  }

  handleEditSaveClick() {
    let month = parseInt(this.state.dateMonthFormValue) - 1;
    let day = parseInt(this.state.dateDayFormValue);
    let year = parseInt(this.state.dateYearFormValue);
    let newStartedAt = new Date(this.props.workTimeUnit.started_at);
    let newFinishedAt = new Date(this.props.workTimeUnit.finished_at);
    newStartedAt.setFullYear(year, month, day);
    newFinishedAt.setFullYear(year, month, day);
    newStartedAt.setHours(parseInt(this.state.startedAtHourFormValue) + (this.state.startedAtAMPMFormValue === 'pm' ? 12 : 0));
    let newStartedAtMinutes = (this.state.startedAtMinuteFormValue === '' ? 0 : parseInt(this.state.startedAtMinuteFormValue));
    newStartedAt.setMinutes(newStartedAtMinutes);
    newFinishedAt.setHours(parseInt(this.state.finishedAtHourFormValue) + (this.state.finishedAtAMPMFormValue === 'pm' ? 12 : 0));
    let newFinishedAtMinutes = (this.state.finishedAtMinuteFormValue === '' ? 0 : parseInt(this.state.finishedAtMinuteFormValue));
    newFinishedAt.setMinutes(newFinishedAtMinutes);
    $.ajax({
      type: 'patch',
      dataType: 'json',
      data: {id: this.props.workTimeUnit.id, work_time_unit: {started_at: newStartedAt, finished_at: newFinishedAt}},
      url: `/work_time_units/${this.props.workTimeUnit.id}`,
      context: this,
      success(data) {
        return this.props.updateWorkTimeUnitAfterEdit(this.props.workTimeUnit, newStartedAt, newFinishedAt, data.total_time_in_seconds);
      },
      error(jqXHR, textStatus, errorThrown) {
        return this.props.pushNotification(`We're sorry. There was an error saving your update to the work time unit. ${errorThrown}`);
      }
    });
    this.props.setEditingWorkTimeUnit(null);
    return this.setState({
      dateMonthFormValue: null,
      dateDayFormValue: null,
      dateYearFormValue: null,
      startedAtHourFormValue: null,
      startedAtMinuteFormValue: null,
      startedAtAMPMFormValue: null,
      finishedAtHourFormValue: null,
      finishedAtMinuteFormValue: null,
      finishedAtAMPMFormValue: null
    });
  }

  handleDeleteClick() {
    if (!this.props.workTimeUnit.finished_at) { return; }
    return this.props.deleteWorkTimeUnit(this.props.workTimeUnit);
  }

  startedAtFormatted() {
    return moment(this.props.workTimeUnit.started_at).format('h:mm a');
  }

  finishedAtFormatted() {
    if (this.props.workTimeUnit.finished_at) {
      return moment(this.props.workTimeUnit.finished_at).format('h:mm a');
    } else {
      return 'still working';
    }
  }

  totalTimeInSecondsFormatted() {
    if (this.props.workTimeUnit.total_time_in_seconds > 3600) {
      return `(${this.roundNumber((this.props.workTimeUnit.total_time_in_seconds / 60 / 60))} hours)`;
    } else if (this.props.workTimeUnit.total_time_in_seconds > 90) {
      return `(${this.roundNumber((this.props.workTimeUnit.total_time_in_seconds / 60))} minutes)`;
    } else if (this.props.workTimeUnit.total_time_in_seconds > 0) {
      return `(${this.roundNumber((this.props.workTimeUnit.total_time_in_seconds))} seconds)`;
    } else {
      return "";
    }
  }

  roundNumber(number) {
    return Math.round( number * 10) / 10;
  }

  buttonClass(buttonType) {
    let cssClass = 'fa';
    if (buttonType === 'edit') { cssClass += ' fa-pencil'; }
    if (buttonType === 'delete') { cssClass += ' fa-trash'; }
    if (!this.props.workTimeUnit.finished_at) { cssClass += ' disabled'; }
    return cssClass;
  }

  render() {
    let editForm;
    if (this.props.workTimeUnit === this.props.editingWorkTimeUnit) {
      editForm = <div>
                  <div>
                    <input className="simple small" placeholder="mm" onChange={this.handleEditDateMonthOnChange} value={this.state.dateMonthFormValue} />
                    <input className="simple small" placeholder="dd" onChange={this.handleEditDateDayOnChange} value={this.state.dateDayFormValue} />
                    <input className="simple small" placeholder="yyyy" onChange={this.handleEditDateYearOnChange} value={this.state.dateYearFormValue} />
                  </div>
                  <div>
                    <input autoFocus className="simple small" placeholder="hh" onChange={this.handleEditStartedAtHourOnChange} value={this.state.startedAtHourFormValue} />
                    <input className="simple small" placeholder="mm" onChange={this.handleEditStartedAtMinuteOnChange} value={this.state.startedAtMinuteFormValue} />
                    <input className="simple small" placeholder="mm" onChange={this.handleEditStartedAtAMPMOnChange} value={this.state.startedAtAMPMFormValue} />
                    <span className="simple-divider">til</span>
                    <input className="simple small" placeholder="hh" onChange={this.handleEditFinishedAtHourOnChange} value={this.state.finishedAtHourFormValue} />
                    <input className="simple small" placeholder="mm" onChange={this.handleEditFinishedAtMinuteOnChange} value={this.state.finishedAtMinuteFormValue} />
                    <input className="simple small" placeholder="mm" onChange={this.handleEditFinishedAtAMPMOnChange} value={this.state.finishedAtAMPMFormValue} />
                    <input className="simple small" type="submit" value="update" onClick={this.handleEditSaveClick} />
                  </div>
                </div>;
    } else {
      editForm = null;
    }
    return <a className='list-group-item work-time-unit'>
      <p><i onClick={this.handleEditClick} className={this.buttonClass('edit')}></i> <i onClick={this.handleDeleteClick} className={this.buttonClass('delete')}></i> Developer: {this.props.workTimeUnit.user_id}
        <span className='pull-right'>
          {this.startedAtFormatted()} - {this.finishedAtFormatted()} <small>{this.totalTimeInSecondsFormatted()}</small>
        </span>
      </p>
      {editForm}
    </a>;
  }
}

window.TimingClockWorkTimeUnit = TimingClockWorkTimeUnit;
