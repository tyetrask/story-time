class UserSettingsChangeToJson < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :settings, :string
    add_column :users, :settings, :json, null: false, default: {}
  end
end
