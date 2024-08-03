class CreateCourses < ActiveRecord::Migration[7.1]
  def change
    create_table :courses, id: :uuid do |t|
      t.string :title, index: true
      t.string :description, index: true

      t.uuid :user_id, index: true
      t.uuid :expertises_ids,    index: true, null: false, array: true, default: []
      t.uuid :liked_user_ids,    index: true, null: false, array: true, default: []
      t.uuid :disliked_user_ids, index: true, null: false, array: true, default: []

      t.integer :total_views, index: false, null: false, default: 1
      t.integer :reviews_count, index: false, null: false, default: 0
      t.integer :appeals_count, index: false, null: false, default: 0

      t.boolean :deleted, index: true, null: false, default: false
      t.timestamps
    end
  end
end
