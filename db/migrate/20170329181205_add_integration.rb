class AddIntegration < ActiveRecord::Migration[5.0]
  def change
    create_table :integrations do |t|
      t.integer :user_id
      t.string  :service_type
      t.string  :username
      t.string  :token
      t.timestamps
    end
    User.all.each do |user|
      Integration.create({service_type: 'pivotaltracker.com', user_id: user.id, username: user.email, token: user.pivotal_api_token})
    end
    remove_column :users, :pivotal_api_token
  end
end
