class AddWorkTimeUnitIntegrationId < ActiveRecord::Migration[5.0]
  def change
    add_column :work_time_units, :integration_id, :integer
  end
end
