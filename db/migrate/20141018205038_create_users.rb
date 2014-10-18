class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :password
      t.string :pivotal_api_token

      t.timestamps
    end
  end
end
