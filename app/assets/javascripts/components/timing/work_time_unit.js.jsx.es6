import React from 'react';
import ReactDOM from 'react-dom';
import { Button } from '@blueprintjs/core';
import { TimePicker, TimePickerPrecision } from '@blueprintjs/datetime';
import moment from 'moment';

class TimingClockWorkTimeUnit extends React.Component {

  constructor() {
    super()
    this.state = {
      startedAtFormValue: null,
      finishedAtFormValue: null
    };
    let methods = [
      'handleEditClick',
      'handleEditSaveClick',
      'handleDeleteClick',
      'startedAtOnChange',
      'finishedAtOnChange'
    ]
    methods.forEach((method) => { this[method] = this[method].bind(this); });
  }

  handleEditClick() {
    if (!this.props.workTimeUnit.finished_at) { return; }
    this.setState({
      startedAtFormValue: moment(this.props.workTimeUnit.started_at).toDate(),
      finishedAtFormValue: moment(this.props.workTimeUnit.finished_at).toDate()
    });
    return this.props.setEditingWorkTimeUnit(this.props.workTimeUnit);
  }

  startedAtOnChange(date) {
    this.setState({startedAtFormValue: date})
  }

  finishedAtOnChange(date) {
    this.setState({finishedAtFormValue: date})
  }

  handleEditSaveClick() {
    $.ajax({
      type: 'patch',
      dataType: 'json',
      data: {id: this.props.workTimeUnit.id, work_time_unit: {started_at: this.state.startedAtFormValue, finished_at: this.state.finishedAtFormValue}},
      url: `/work_time_units/${this.props.workTimeUnit.id}`,
      context: this,
      success(data) {
        return this.props.updateWorkTimeUnitAfterEdit(this.props.workTimeUnit, data.started_at, data.finished_at, data.total_time_in_seconds);
      },
      error(jqXHR, textStatus, errorThrown) {
        return this.props.pushNotification({
          message: `We're sorry. There was an error saving your update to the work time unit. ${errorThrown}`,
          intent: Intent.DANGER
        });
      }
    });
    this.props.setEditingWorkTimeUnit(null);
    return this.setState({
      startedAtFormValue: null,
      finishedAtFormValue: null
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
      return `${this.roundNumber((this.props.workTimeUnit.total_time_in_seconds / 60 / 60))} hours`;
    } else if (this.props.workTimeUnit.total_time_in_seconds > 90) {
      return `${this.roundNumber((this.props.workTimeUnit.total_time_in_seconds / 60))} minutes`;
    } else if (this.props.workTimeUnit.total_time_in_seconds > 0) {
      return `${this.roundNumber((this.props.workTimeUnit.total_time_in_seconds))} seconds`;
    } else {
      return "";
    }
  }

  roundNumber(number) {
    return Math.round( number * 10) / 10;
  }

  buttonClass(buttonType) {
    let cssClass = 'fa';
    if (buttonType === 'edit') {
      cssClass += ' fa-pencil';
    } else if (buttonType === 'delete') {
      cssClass += ' fa-trash';
    }
    return cssClass;
  }

  buttonProps(buttonType) {
    let props = {};
    if (buttonType === 'edit') {
      props.onClick = this.handleEditClick;
    } else if (buttonType === 'delete') {
      props.onClick = this.handleDeleteClick;
    }
    if (!this.props.workTimeUnit.finished_at) {
      props.disabled = true;
    }
    return props;
  }

  render() {
    let editForm;
    if (this.props.workTimeUnit === this.props.editingWorkTimeUnit) {
      editForm = <div>
                  <TimePicker
                    value={this.state.startedAtFormValue}
                    onChange={this.startedAtOnChange}
                    precision={TimePickerPrecision.SECOND}
                    showArrowButtons={true}
                  />
                  <TimePicker
                    value={this.state.finishedAtFormValue}
                    onChange={this.finishedAtOnChange}
                    precision={TimePickerPrecision.SECOND}
                    showArrowButtons={true}
                  />
                  <a className="pt-button" onClick={this.handleEditSaveClick}>Save</a>
                </div>;
    } else {
      editForm = null;
    }
    return <div className='pt-card pt-elevation-1 work-time-unit'>
            <div>
              <div className="pt-button-group">
                <Button {...this.buttonProps('edit')}>
                  <i className={this.buttonClass('edit')}></i>
                </Button>
                <Button {...this.buttonProps('delete')}>
                  <i className={this.buttonClass('delete')}></i>
                </Button>
              </div>
              <span> {this.totalTimeInSecondsFormatted()} <small>({this.startedAtFormatted()} - {this.finishedAtFormatted()})</small></span>
              <span className='pull-right'>
                Developer: {this.props.workTimeUnit.integration_user_id}
              </span>
            </div>
            {editForm}
          </div>;
  }
}

window.TimingClockWorkTimeUnit = TimingClockWorkTimeUnit;
