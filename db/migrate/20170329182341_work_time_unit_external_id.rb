class WorkTimeUnitExternalId < ActiveRecord::Migration[5.0]
  def change
    rename_column :work_time_units, :user_id, :integration_user_id
  end
end
