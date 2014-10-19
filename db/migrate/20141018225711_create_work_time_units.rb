class CreateWorkTimeUnits < ActiveRecord::Migration
  def change
    create_table :work_time_units do |t|
      t.string :user_id
      t.integer :pivotal_story_id
      t.datetime :started_at
      t.datetime :finished_at
      t.integer :total_time_in_seconds

      t.timestamps
    end
  end
end
