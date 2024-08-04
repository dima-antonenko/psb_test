class CreateSupportRequests < ActiveRecord::Migration[7.1]
  def change
    create_table :support_requests do |t|
      t.integer :user_id, index: true
      t.string :name, index: true
      t.string :email, index: true
      t.text :message
      t.boolean :viewed, index: true
      t.timestamps

    end
  end
end
