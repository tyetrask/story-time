class AddProjectIdToWorkTimeUnits < ActiveRecord::Migration
  def change
    add_column :work_time_units, :project_id, :integer
  end
end
