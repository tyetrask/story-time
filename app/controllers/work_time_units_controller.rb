class WorkTimeUnitsController < ApplicationController
  before_action :set_scope, only: [:index]
  before_action :set_work_time_unit, only: [:show, :edit, :update, :destroy]

  # GET /work_time_units
  # GET /work_time_units.json
  def index
    @work_time_units
  end

  # GET /work_time_units/1
  # GET /work_time_units/1.json
  def show
  end

  # GET /work_time_units/new
  def new
    @work_time_unit = WorkTimeUnit.new
  end

  # GET /work_time_units/1/edit
  def edit
  end

  # POST /work_time_units
  # POST /work_time_units.json
  def create
    @work_time_unit = WorkTimeUnit.new(work_time_unit_params)
    respond_to do |format|
      if @work_time_unit.save
        format.html { redirect_to @work_time_unit, notice: 'Work time unit was successfully created.' }
        format.json { render action: 'show', status: :created, location: @work_time_unit }
      else
        format.html { render action: 'new' }
        format.json { render json: @work_time_unit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /work_time_units/1
  # PATCH/PUT /work_time_units/1.json
  def update
    respond_to do |format|
      if @work_time_unit.update(work_time_unit_params)
        format.html { redirect_to @work_time_unit, notice: 'Work time unit was successfully updated.' }
        format.json { render json: @work_time_unit }
      else
        format.html { render action: 'edit' }
        format.json { render json: @work_time_unit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /work_time_units/1
  # DELETE /work_time_units/1.json
  def destroy
    @work_time_unit.destroy
    respond_to do |format|
      format.html { redirect_to work_time_units_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_work_time_unit
      @work_time_unit = WorkTimeUnit.find(params[:id])
    end

    def set_scope
      @work_time_units = WorkTimeUnit.all
      @work_time_units = @work_time_units.where(project_id: work_time_unit_params[:project_id], story_id: work_time_unit_params[:story_id]) if work_time_unit_params[:story_id] and work_time_unit_params[:project_id]
      @work_time_units = @work_time_units.where(finished_at: nil, user_id: work_time_unit_params[:user_id]) if params[:open_work_time_units]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def work_time_unit_params
      params.require(:work_time_unit).permit(:user_id, :project_id, :story_id, :started_at, :finished_at, :total_time_in_seconds)
    end
end
