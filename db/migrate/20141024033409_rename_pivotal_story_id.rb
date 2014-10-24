class RenamePivotalStoryId < ActiveRecord::Migration
  def change
    rename_column :work_time_units, :pivotal_story_id, :story_id
  end
end
