class AddConcentrationModeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :concentration_mode, :boolean, default: false, null: false
  end
end
