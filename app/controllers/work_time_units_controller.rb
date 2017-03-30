class WorkTimeUnitsController < ApplicationController
  before_action :set_scope, only: [:index]
  before_action :set_work_time_unit, only: [:update, :destroy]

  def index
    @work_time_units
  end

  def create
    @work_time_unit = WorkTimeUnit.new(work_time_unit_params)
    respond_to do |format|
      if @work_time_unit.save
        format.json { render json: @work_time_unit, status: :created }
      else
        format.json { render json: @work_time_unit.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @work_time_unit.update(work_time_unit_params)
        format.json { render json: @work_time_unit }
      else
        format.json { render json: @work_time_unit.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @work_time_unit.destroy
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private

    def set_work_time_unit
      @work_time_unit = WorkTimeUnit.find(params[:id])
    end

    def set_scope
      @work_time_units = WorkTimeUnit.all
      @work_time_units = @work_time_units.where(project_id: work_time_unit_params[:project_id], story_id: work_time_unit_params[:story_id]) if work_time_unit_params[:story_id] and work_time_unit_params[:project_id]
      @work_time_units = @work_time_units.where(finished_at: nil, integration_user_id: work_time_unit_params[:integration_user_id]) if params[:open_work_time_units]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def work_time_unit_params
      params.require(:work_time_unit).permit(:integration_id, :integration_user_id, :project_id, :story_id, :started_at, :finished_at, :total_time_in_seconds)
    end
end
