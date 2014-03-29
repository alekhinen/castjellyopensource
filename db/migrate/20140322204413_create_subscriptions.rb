class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.integer :user_id
      t.integer :podcast_id
      t.datetime :created_at

      t.timestamps
    end
  end
end
