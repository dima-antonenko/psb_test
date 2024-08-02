class CreateNetworkLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :network_logs do |t|
      t.uuid :user_id, index: true
      t.string :event_type, index: true, null: false

      t.string :logable_type, index: true
      t.uuid   :logable_id,   index: true

      t.string :ip, index: true
      t.string :user_agent, index: true

      t.timestamps
    end
  end
end
